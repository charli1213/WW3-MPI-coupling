import numpy as np
import xarray as xr
from   datetime import datetime, timedelta
import PARAMS

# > Importing PARAMS
# grid parameters
nx    = PARAMS.nx #(513)
ny    = PARAMS.ny #(513)
dx    = PARAMS.dx #(2000000/(514-2))
dy    = PARAMS.dy
Lx    = PARAMS.Lx
Ly    = PARAMS.Ly

# Wind parameters
input_period  = PARAMS.input_period
filesperday   = 1/input_period
tau_wind      = PARAMS.tau_wind
ndays         = PARAMS.ndays       # [jours]
date_start    = PARAMS.date_start


# --- Charnok relation (from Gill 1982, p30) parameters.
cd = (1.1*1e-3)
VKarman = 0.4
Charnok = 0.0185
rho_a   = 1.275    #[Kg/m3]
z_alti  = 10       #[m]
g       = 9.81     #[m/s^2]

print("BUILD_WIND_FORCING : FROM {} to {}".format(PARAMS.date_start,PARAMS.date_end))

# ======================== Grid Definition ========================== #
# -------------------------- Grid Settings -------------------------- #
# Time settings for the NetCDF 
nt          = int(ndays*filesperday)+1  # Nombre d'itérations
dt          = int(86400*input_period)   # Temps par itération
datetime_array = np.array([date_start + timedelta(seconds=int(dt*it)) for it in range(nt)])

# Creating dims arrays.
xcoords_array  = np.linspace(0,Lx,nx)
ycoords_array  = np.linspace(0,Ly,ny)

# ---------------------- DataArray preparation ---------------------- #
tcoords_da = xr.DataArray(datetime_array, dims = {'time'}, attrs = {'units':'$s$'})
xcoords_da = xr.DataArray(xcoords_array,  dims = {'x'},    attrs = {'units':'$m$'})
ycoords_da = xr.DataArray(ycoords_array,  dims = {'y'},    attrs = {'units':'$m$'})


# ==================== Forcing Grid Definition ====================== #
# ------------------------ WIND definition -------------------------- #
Imat,Jmat = np.meshgrid(ycoords_array,xcoords_array,indexing='ij')

# defining the wind forcing fields. 
U_wind = Imat*0.
V_wind = Jmat*0.

# Jet wind
# Tau0(y) = rho*cd*u^2(y)
# Tau0 = tau_wind**np.sin( 2*np.pi*(Y+0.5)/(ny-1))

# On crée le forçage tau. C'est le meme forçage qu'on donnait au
# modèle shallow-water. 

Xtau = tau_wind*(1-np.cos(2*np.pi*(Imat-dy)/(Ly-2*dy)))

# Calculating cd matrix :
cd  = 0*Xtau.copy()
for i in range(ny) :
    for j in range(nx) :
        if Xtau[i,j]==0. :
            cd[i,j] = 0
        else : 
            cd[i,j] = (VKarman/np.log((rho_a*g*z_alti)/(Charnok*abs(Xtau[i,j]))))**2

# On trouve le vent qui lui est associé.
for i in range(ny) :
    for j in range(nx) :
        if Xtau[i,j] > 0 :
            U_wind[i,j] = np.sqrt(abs(Xtau[i,j])/(rho_a*cd[i,j]))
        elif Xtau[i,j] < 0:
            U_wind[i,j] = -np.sqrt(abs(Xtau[i,j])/(rho_a*cd[i,j]))
        else :
            U_wind[i,j] = 0


V_wind[:,:] = 0. # North/South wind is nul.

# Creating 3d Prism to add time to our velocities.
U_wind_timed = np.zeros((nt,ny,nx))
V_wind_timed = np.zeros((nt,ny,nx))

# Introduction of the varying wind force across period.
for it in range(nt) :
    U_wind_timed[it,:,:] = U_wind[:,:]
    V_wind_timed[it,:,:] = V_wind[:,:]

    
# -------------------------------------------------------------------- #
# DataArray coordinates
system_coords = {'time':datetime_array,'y':ycoords_da,'x':xcoords_da}
system_dims   = ['time','y','x']
system_attrs  = {'nx':nx, 'ny':ny, 'units':'m/s',
                 'dx':dx, 'dy':dy, 'Lx':Lx, 'Ly':Ly}

# Wind DataArrays
U_wind_da = xr.DataArray(U_wind_timed, coords = system_coords, 
                         dims = system_dims, 
                         attrs = {'long_name':'Eastward Wind Velocity'})

V_wind_da = xr.DataArray(V_wind_timed, coords = system_coords, 
                         dims = system_dims, 
                         attrs = {'long_name':'Northward Wind Velocity'})

U_wind_da.attrs.update(system_attrs)
V_wind_da.attrs.update(system_attrs)


# ------------------- Dataset/NetCDF Creation ------------------------ #
ds_final = xr.Dataset({'U_wind':U_wind_da, 'V_wind':V_wind_da}, 
                attrs = system_attrs)
ds_final.attrs.update({'long_name':'Wavewatch III Boundary Conditions',
                 'name': 'Boundary Conditions'})

ds_final[['time','y','x','U_wind','V_wind']].to_netcdf('../work/WW3Windforcings.nc', encoding={'time':{'dtype':'float64','units':'days since 2019-01-01'}})


# N.B. Coordinates AND array must be ordered like  [['time','y','x','U_cur','V_cur']]

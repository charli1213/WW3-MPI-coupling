import numpy as np
import xarray as xr
from   datetime import datetime, timedelta
import PARAMS

# > Importing PARAMS
ncpath = PARAMS.ncpath

# grid parameters
nx    = PARAMS.nx #(513)
ny    = PARAMS.ny #(513)
dx    = PARAMS.dx #(2000000/(514-2))
dy    = PARAMS.dy
Lx    = PARAMS.Lx
Ly    = PARAMS.Ly

# Current parameters
input_period  = 365
filesperday   = 1/input_period
current_speed = PARAMS.current_speed
ndays         = PARAMS.ndays       # [jours]
date_start    = PARAMS.date_start

print("BUILD_CURRENT_FORCING : FROM {} to {}".format(PARAMS.date_start,PARAMS.date_end))

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
xcoords_da = xr.DataArray(xcoords_array,  dims = {'x'}, attrs = {'units':'$m$'})
ycoords_da = xr.DataArray(ycoords_array,  dims = {'y'}, attrs = {'units':'$m$'})


# ==================== Forcing Grid Definition ====================== #
# ------------------------ WIND definition -------------------------- #
Imat,Jmat = np.meshgrid(ycoords_array,xcoords_array,indexing='ij')

# defining the wind forcing fields. 
U_cur = Imat*0.
V_cur = Jmat*0.

# Creating 3d Prism to add time to our velocities.
U_cur_timed = np.zeros((nt,ny,nx))
V_cur_timed = np.zeros((nt,ny,nx))

# Introduction of the varying wind force across period.
for it in range(nt) :
    U_cur_timed[it,:,:] = U_cur[:,:]
    V_cur_timed[it,:,:] = V_cur[:,:]

    
# -------------------------------------------------------------------- #
# DataArray coordinates
system_coords = {'time':datetime_array,'y':ycoords_da,'x':xcoords_da}
system_dims   = ['time','y','x']
system_attrs  = {'nx':nx, 'ny':ny, 'units':'m/s',
                 'dx':dx, 'dy':dy, 'Lx':Lx, 'Ly':Ly}

#Currents DataArrays
U_cur_da = xr.DataArray(U_cur_timed, coords = system_coords, 
                         dims = system_dims, 
                         attrs = {'long_name':'Eastward Current Velocity'})

V_cur_da = xr.DataArray(V_cur_timed, coords = system_coords, 
                         dims = system_dims, 
                         attrs = {'long_name':'Northward Current Velocity'})

U_cur_da.attrs.update(system_attrs)
V_cur_da.attrs.update(system_attrs)


# ------------------- Dataset/NetCDF Creation ------------------------ #
ds_final = xr.Dataset({'U_cur':U_cur_da, 'V_cur':V_cur_da}, 
                attrs = system_attrs)
ds_final.attrs.update({'long_name':'Wavewatch III Boundary Conditions',
                 'name': 'Boundary Conditions'})

ds_final[['time','y','x','U_cur','V_cur']].to_netcdf(ncpath+'WW3Currentforcings.nc', encoding={'time':{'dtype':'float64','units':'days since 2019-01-01'}})

# N.B. Coordinates AND array must be ordered like  [['time','y','x','U_cur','V_cur']]

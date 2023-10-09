from datetime import datetime, timedelta

# > PARAMETERS :
# Grille
inner_nx = 512
inner_ny = 512
nx   = inner_nx+2    # [ - ] (512 + 2) On compte les murs dans WW3
ny   = inner_ny+2    # [ - ] (512 + 2) On compte les murs dans WW3
Lx   = 2e6*(nx)/inner_nx
Ly   = 2e6*(ny)/inner_ny
dx   = Lx/(inner_nx)  # [ m ]
dy   = Ly/(inner_ny)  # [ m ]

# Champs de vagues au début (Voir ww3_strt.inp)
start = 5 # Starting from calm conditions.

# Current/Wind input
input_period  = 1 # [days]
current_speed = 0.0
step          = 0.0 # [%]
tau_wind      = 0.05
ndays         = 365*5  # [days] Model run 

# Time
decalage   = timedelta(days=0)
date_start = datetime(2019,1,1,0,0) + decalage
date_end   = date_start + timedelta(days=ndays)



filesperday = 4 #24 #Frequency of inputs. 4



# Forcing params. 
frequency   = 7e-5    # [rad/sec] Frequency of wind.
max_tau0    = 0.1    # [N/m^2]
step        = 0.05    # [ % ]
# ================================= #


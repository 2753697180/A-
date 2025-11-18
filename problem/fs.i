T_in = 300. # K
m_dot_in = 0.01# kg/s
press = 30e5 # Pa
# core_pipe parameters
core_D=${units 2 cm -> m}
core_A=${fparse 0.25 * pi * core_D^2}
length= 0.5 # m
nub_elems=25 # number of elements in the core pipe
# derived parameters
rho=${fparse press/( 2078.6*T_in)} # ideal gas law
vel=${fparse m_dot_in/(rho*core_A)} # m/s
#P_hf=${fparse 0.031286893008046/length} # m
[GlobalParams]
  initial_p = ${press} 
  initial_T = ${T_in}
  initial_vel=${vel}
  gravity_vector = '0 0 0'
  rdg_slope_reconstruction = minmod
  scaling_factor_1phase = '1 1e-2 1e-4'
  closures = thm_closures
  fp=he
[]
[FluidProperties]
  [he]
    type = IdealGasFluidProperties
    molar_mass = 4e-3
    gamma = 1.67
    k = 0.2556
    mu = 3.22639e-5
  []
[]
[Closures]
  [thm_closures]
    type = Closures1PhaseTHM
  []
[]
[AuxVariables]
  [htc]
    family = MONOMIAL
    order  = CONSTANT
    block  = core1
  []
  [T_w]
    family = MONOMIAL
    order  = CONSTANT
    initial_condition = 300
    block  = core1
  []
  [A_ss]
    family = MONOMIAL
    order  = CONSTANT
    #initial_condition = 3.1447341926e-4
    initial_condition = 3.174e-4
  []
  [A_dt]
    family = LAGRANGE
    order  = FIRST
   # initial_condition = 3.1447341926e-4
    initial_condition = 3.174e-4
  []
[]
[AuxKernels]
  [htc_kernel]
    type = ProjectionAux
    v = A_ss
    variable = A_dt
  []
[]
[Materials]
  [htc_material]
    type = newarea
    area=A_ss
    area_grad = A_dt
    A=A
  []
[]
[Components]
  [core1]
    type = FlowChannel1Phase
    position = '0 0 0'
    orientation = '0 0 1'
    length = ${length}
    n_elems =${nub_elems}
    A = ${core_A}
    D_h = ${core_D}
    f=0
    wave_speed_formulation=einfeldt
  []
  [inlet]
    type = InletMassFlowRateTemperature1Phase
    input = 'core1:in'
    m_dot = ${m_dot_in}
    T = ${T_in}
  []
  [outlet]
    type = Outlet1Phase
    input = 'core1:out'
    p = ${press}
  []
  [bc]
   type= HeatTransferFromSpecifiedTemperature1Phase
   T_wall = 400
   flow_channel = core1 
  []
[]
[Preconditioning]
  [pc]
    type = SMP
    full = true
    solve_type = PJFNK
    #trust_my_coupling = true
  []
[]
[Executioner]
  type = Transient
  solve_type = PJFNK
  line_search = basic
  start_time = 0
  end_time =1
  dt=1e-3
  dtmin = 1e-8
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package -ksp_type'
  petsc_options_value = 'lu superlu_dist gmres'
  reuse_preconditioner = true
  reuse_preconditioner_max_linear_its = '20'
  nl_rel_tol = 1e-5
  nl_abs_tol = 1e-8
  nl_max_its = 25
  scheme= implicit-euler
  automatic_scaling  =  true
[]
[Outputs]
  exodus = true
  [console]
    type = Console
    max_rows = 1
    outlier_variable_norms = false
  []
  print_linear_residuals = false
  file_base = 25_T
[]



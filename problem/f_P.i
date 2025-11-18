T_in = 300. # K
m_dot_in = 0.01# kg/s
press = 30e5 # Pa
# core_pipe parameters

length= 0.5 # m
core_D=${fparse 0.031286893008046/length/pi}
core_A=${fparse 0.25*pi*core_D^2} # m^2
nub_elems=25 # number of elements in the core pipe
# pipe parameters
pipe_dia = ${units 2 cm -> m}
A_pipe = ${fparse 0.25 * pi * pipe_dia^2}
vol =1e-5 #
# derived parameters
rho=${fparse press/( 2078.6*T_in)} # ideal gas law
vel=${fparse m_dot_in/(rho*core_A)}
vel_pipe=${fparse m_dot_in/(rho*A_pipe)}
P_hf=${fparse pi*core_D} # m
# heat exchanger parameters
hx_dia_inner = '${units 2 cm -> m}'
hx_wall_thickness = '${units 5 mm -> m}'
hx_dia_outer = '${units 10. cm -> m}'
hx_radius_wall = '${fparse hx_dia_inner / 2. + hx_wall_thickness}'
hx_length = 1.1 # m
hx_n_elems = 25
m_dot_sec_in = 1 # kg/s
[GlobalParams]
  initial_p = ${press} 
  initial_T = ${T_in}
  initial_vel=${vel_pipe}
  gravity_vector = '0 0 0'
  rdg_slope_reconstruction = minmod
  scaling_factor_1phase = '1 1e-2 1e-4'
  closures = thm_closures
  fp=he
  initial_vel_x = 0
  initial_vel_y = 0
  initial_vel_z = 0
  scaling_factor_rhoV = 1
  scaling_factor_rhouV = 1e-2
  scaling_factor_rhovV = 1e-2
  scaling_factor_rhowV = 1e-2
  scaling_factor_rhoEV = 1e-4
[]
[FluidProperties]
  [he]
    type = IdealGasFluidProperties
    molar_mass = 4e-3
    gamma = 1.67
    k = 0.2556
    mu = 3.22639e-5
  []
  [water]
    type = StiffenedGasFluidProperties
    gamma = 2.35
    cv = 1816.0
    q = -1.167e6
    p_inf = 1.0e9
    q_prime = 0
  []
[]
[SolidProperties]
  [steel]
    type = ThermalFunctionSolidProperties
    rho = 8000
    k = 45
    cp = 466
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
    block  = core1
    initial_condition = 3.14e-4
  []
[]
[AuxKernels]
  [hw]
    type = ADMaterialRealAux
    variable = htc
    property = 'Hw'
  []
[]
[Components]
  [pipe1]
    type = FlowChannel1Phase
    position = '0 0 -0.5'
    orientation = '0 0 1'
    length = 0.5
    n_elems = 15
    A = ${A_pipe}
    D_h = ${pipe_dia}
  []
  [core1]
    type = FlowChannel1Phase
    position = '0 0 0'
    orientation = '0 0 1'
    length = ${length}
    n_elems =${nub_elems}
    A =  ${core_A}
    D_h = ${core_D}
    initial_vel = ${vel}
  []
  [jct1]
    type = VolumeJunction1Phase
    position = '0 0 0'
    connections = 'pipe1:out core1:in '
    volume = 1e-5
  []
  [pipe2]
    type = FlowChannel1Phase
    position = '0 0 0.5'
    orientation = '0 0 1'
    length = 0.5
    n_elems = 15
    A = ${A_pipe}
    D_h = ${pipe_dia}
  []
  [jct2]
    type =VolumeJunction1Phase
    position = '0 0 0.5'
    connections = 'core1:out pipe2:in'
    volume = 1e-5
    use_scalar_variables = false  
  []
  [jct3]
    type =VolumeJunction1Phase
    position = '0 0 1.00'
    volume = ${vol}
    connections = 'pipe2:out top_pipe_1:in' 
  []
  [top_pipe_1]
    type = FlowChannel1Phase
    position = '0 0 1.00'
    orientation = '1 0 0'
    length = 0.5
    n_elems = 10
    A = ${A_pipe}
    D_h = ${pipe_dia}
  []
  [top_pipe_2]
    type = FlowChannel1Phase
    position = '0.5 0 1.00'
    orientation = '1 0 0'
    length = 0.5
    n_elems = 20
    A = ${A_pipe}
    D_h = ${pipe_dia}
  []
  [press_pipe]
    type = FlowChannel1Phase
    position = '0.5 0 1.00'
    orientation = '0 0 1 '
    length = 0.2
    n_elems = 5
    A = ${A_pipe}
    D_h = ${pipe_dia}
  []
  [jct4]
    type = VolumeJunction1Phase
    position = '0.5 0 1.00'
    volume = ${vol}
    connections = 'top_pipe_1:out top_pipe_2:in press_pipe:in'
  []
  [jct5]
    type = VolumeJunction1Phase
    position = '1 0 1.00'
    volume = ${vol}
    connections = 'top_pipe_2:out down_pipe_1:in '
  []
  [down_pipe_1]
    type = FlowChannel1Phase
    position = '1 0 1.00'
    orientation = '0 0 -1'
    length = 0.2
    A = ${A_pipe}
    D_h = ${pipe_dia}
    n_elems = 10
    fp = he
  []
  [jct6]
    type = VolumeJunction1Phase
    position = '1 0 0.8'
    volume = ${vol}
    connections = 'down_pipe_1:out pri:in'
  []
  [pri]
      type = FlowChannel1Phase
      position = '1 0 0.8'
      orientation = '0 0 -1'
      length = ${hx_length}
      n_elems = ${hx_n_elems}
      roughness = 1e-5
      A = '${fparse pi * hx_dia_inner * hx_dia_inner / 4.}'
      D_h = ${hx_dia_inner}
  []
  [wall]
      type = HeatStructureCylindrical
      position = '1 0 0.8'
      orientation = '0 0 -1'
      length = ${hx_length}
      n_elems = ${hx_n_elems}
      widths = '${hx_wall_thickness}'
      n_part_elems = '3'
      solid_properties = 'steel'
      solid_properties_T_ref = '300'
      names = '0'
      inner_radius = '${fparse hx_dia_inner / 2.}'
      initial_T = 300
  []
  [sec]
      type = FlowChannel1Phase
      position = '1 0 -0.3'
      orientation = '0 0 1'
      length = ${hx_length}
      n_elems = ${hx_n_elems}
      A = '${fparse pi * (hx_dia_outer * hx_dia_outer / 4. - hx_radius_wall * hx_radius_wall)}'
      D_h = '${fparse hx_dia_outer - (2 * hx_radius_wall)}'
      fp = water
      initial_T = 300
  []
  [jct7]
    type = VolumeJunction1Phase
    position = '1 0 -0.3'
    volume = ${vol}
    connections = 'pri:out down_pipe_2:in'
  []
  [down_pipe_2]
    type = FlowChannel1Phase
    position = '1 0 -0.3'
    orientation = '0 0 -1'
    length = 0.2
    n_elems = 10
    A = ${A_pipe}
    D_h = ${pipe_dia}
  []
  [jct8]
    type = VolumeJunction1Phase
    position = '1 0 -0.5'
    volume = ${vol}
    connections = 'down_pipe_2:out bottom_1:in'
  []
  [bottom_1]
    type = FlowChannel1Phase
    position = '1 0 -0.5'
    orientation = '-1 0 0'
    length = 0.5
    n_elems = 10
    A = ${A_pipe}
    D_h = ${pipe_dia}
    fp = he
  []
  [bottom_2]
    type = FlowChannel1Phase
    position = '0.5 0 -0.5'
    orientation = '-1 0 0'
    length = 0.5
    n_elems = 10
    A = ${A_pipe}
    D_h = ${ pipe_dia}
    fp = he
  []
  [pump]
    type = Pump1Phase
    position = '0.5 0 -0.5'
    connections = 'bottom_1:out bottom_2:in'
    volume = ${vol}
    A_ref = ${A_pipe}
    head = 0
    initial_T = 300
  []
  [jct9]
    type = VolumeJunction1Phase
    position = '0 0 -0.5'
    volume = ${vol}
    connections = 'bottom_2:out pipe1:in'
  []
  #############boundry condition
  [pressurizer]
    type = Outlet1Phase
    input = 'press_pipe:out'
    p = ${press}
  []
  [inlet_sec]
    type = InletMassFlowRateTemperature1Phase
    input = 'sec:in'
    m_dot =${m_dot_sec_in}
    T = 300
  []
  [outlet_sec]
    type = Outlet1Phase
    input = 'sec:out'
    p = ${press}
  []
  [ht_pri]
      type = HeatTransferFromHeatStructure1Phase
      hs = wall
      hs_side = inner
      flow_channel = pri
      P_hf = '${fparse pi * hx_dia_inner}'
      scale = 4
  []
  [ht_sec]
      type = HeatTransferFromHeatStructure1Phase
      hs = wall
      hs_side = outer
      flow_channel = sec
      P_hf = '${fparse 2 * pi * hx_radius_wall}' 
      scale = 4
  []
######
  [bc]
    type = HeatTransferFromExternalAppTemperature1Phase
    flow_channel =core1
    T_ext = T_w
    var_type = ELEMENTAL
  []
[]
[Preconditioning]
  [pc]
    type = SMP
    full = true
  []
[]
[ControlLogic]
  [set_point]
    type = GetFunctionValueControl
    function = ${m_dot_in}
  []
  [pid]
    type = PIDControl
    initial_value = 33.5
    set_point = set_point:value
    input = m_dot_pump
    K_p = 10
    K_i = 400
    K_d = 0
  []
  [set_pump_head]
    type = SetComponentRealValueControl
    component = pump
    parameter = head
    value = pid:output
  []
[]
[Postprocessors]
 [T_wall]
  type = ElementAverageValue
  variable = T_w
  block = core1
 # execute_on = 'timestep_begin'
 []
 [T_fluid]
  type = ElementAverageValue
  variable = T
  block = core1
 # execute_on = 'timestep_begin'
 []
  [htc]
  type = ElementAverageValue
  variable = htc
  block = core1
 #execute_on = 'timestep_begin'
 []
  [q]
  type = ADHeatRateConvection1Phase
  P_hf = ${P_hf}
  T_wall = T_w
  T=T
  Hw=Hw
  block = core1
 # execute_on = 'timestep_begin'
  []
  [m_dot_pump]
    type = ADFlowJunctionFlux1Phase
    boundary = bottom_2:out
    connection_index = 0
    equation = mass
    junction = jct9
  []
  [pump_head]
    type = RealComponentParameterValuePostprocessor
    component = pump
    parameter = head
  []
[]
[Executioner]
  type = Transient
  solve_type = PJFNK
  line_search = basic
  start_time = 0
  end_time =50
  dt = 0.001
  dtmin=1e-4
  petsc_options_iname = '-pc_type'
  petsc_options_value = 'lu'
  nl_rel_tol = 1e-5
  nl_abs_tol = 1e-8
  nl_max_its = 25
[]
[Outputs]
  exodus = true
  [console]
    type = Console
    max_rows = 1
    outlier_variable_norms = false
  []
  [csv]
    type = CSV
     # append_date=true
  []
  print_linear_residuals = false
[]


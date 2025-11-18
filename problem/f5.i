#global params
T_in = 300. # K
press = 30e5 # Pa
vol=1e-5#
m_dot_in=1e-2 # kg/s
# core parameters
core_length=0.50 #m
core_elems=25
core_dia = '${units 2 cm -> m}'
core_A_pipe = '${fparse 0.25 * pi * core_dia^2}'
# pipe parameters
pipe_dia = '${units 10 cm -> m}'
A_pipe = '${fparse 0.25 * pi * pipe_dia^2}'
core_inv='${fparse m_dot_in/core_A_pipe/4.8}'#m/s
# heat exchanger parameters
hx_dia_inner = '${units 10 cm -> m}'
hx_wall_thickness = '${units 5 mm -> m}'
hx_dia_outer = '${units 20. cm -> m}'
hx_radius_wall = '${fparse hx_dia_inner / 2. + hx_wall_thickness}'
hx_length = 1.1 # m
hx_n_elems = 25
m_dot_sec_in = 1 # kg/s
[GlobalParams]
  initial_p = ${press} 
  initial_T = ${T_in}
  initial_vel= '${fparse m_dot_in/A_pipe/4.8}'
  gravity_vector = '0 0 -9.81'
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
[Closures]
  [thm_closures]
    type = Closures1PhaseTHM
  []
[]
[SolidProperties]
  [steel]
    type = ThermalFunctionSolidProperties
    rho = 8050
    k = 45
    cp = 466
  []
[]
[AuxVariables]
  [htc]
    family = MONOMIAL
    order = CONSTANT
    block = 'core1 core2 core3 core4 core5 core6 core7 core8 core9 core10 core11 core12'
  []
  [T_w]
    family = MONOMIAL
    order = CONSTANT
    initial_condition = 400
    block = 'core1 core2 core3 core4 core5 core6 core7 core8 core9 core10 core11 core12'
  []
[]
[Components]
  [up_pipe_1]
    type = FlowChannel1Phase
    position = '0 0 -0.5'
    orientation = '0 0 1'
    length = 0.5
    n_elems = 25
    A = ${A_pipe}
    D_h = ${pipe_dia}
  []
  ####core_inner
  [core1]
    type = FlowChannel1Phase
    position = '-0.010 0.01732 0'
    orientation = '0 0 1'
    length = ${core_length}
    n_elems = ${core_elems}
    A = ${core_A_pipe}
    D_h = ${core_dia}
    initial_vel = ${core_inv}
  []
  [core2]
    type = FlowChannel1Phase
    position = '-0.02 0 0'
    orientation = '0 0 1'
    length = ${core_length}
    n_elems = ${core_elems}
    A = ${core_A_pipe}
    D_h = ${core_dia}
    initial_vel = ${core_inv}
  []
  [core3]
    type = FlowChannel1Phase
    position = '-0.010 -0.01732 0'
    orientation = '0 0 1'
    length = ${core_length}
    n_elems = ${core_elems}
    A = ${core_A_pipe}
    D_h = ${core_dia}
    initial_vel = ${core_inv}
  []
  [core4]
    type = FlowChannel1Phase
    position = '0.010 -0.01732 0'
    orientation = '0 0 1'
    length = ${core_length}
    n_elems = ${core_elems}
    A = ${core_A_pipe}
    D_h = ${core_dia}
    initial_vel = ${core_inv}
  []
  [core5]
    type = FlowChannel1Phase
    position = '0.02 0 0'
    orientation = '0 0 1'
    length = ${core_length}
    n_elems = ${core_elems}
    A = ${core_A_pipe}
    D_h = ${core_dia}
    initial_vel = ${core_inv}
  []
  [core6]
    type = FlowChannel1Phase
    position = '0.010 0.01732 0'
    orientation = '0 0 1'
    length = ${core_length}
    n_elems = ${core_elems}
    A = ${core_A_pipe}
    D_h = ${core_dia}
    initial_vel = ${core_inv}
  []
  #####core_outer
  [core7]
    type = FlowChannel1Phase
    position = '-0.020 0.03464 0'
    orientation = '0 0 1'
    length = ${core_length}
    n_elems = ${core_elems}
    A = ${core_A_pipe}
    D_h = ${core_dia}
    initial_vel = ${core_inv}
  []
  [core8]
    type = FlowChannel1Phase
    position = '-0.04 0 0'
    orientation = '0 0 1'
    length = ${core_length}
    n_elems = ${core_elems}
    A = ${core_A_pipe}
    D_h = ${core_dia}
    initial_vel = ${core_inv}
  []
  [core9]
    type = FlowChannel1Phase
    position = '-0.020 -0.03464 0'
    orientation = '0 0 1'
    length = ${core_length}
    n_elems = ${core_elems}
    A = ${core_A_pipe}
    D_h = ${core_dia}
    initial_vel = ${core_inv}
  []
  [core10]
    type = FlowChannel1Phase
    position = '0.020 -0.03464 0'
    orientation = '0 0 1'
    length = ${core_length}
    n_elems = ${core_elems}
    A = ${core_A_pipe}
    D_h = ${core_dia}
    initial_vel = ${core_inv}
  []
  [core11]
    type = FlowChannel1Phase
    position = '0.040 0 0'
    orientation = '0 0 1'
      length = ${core_length}
    n_elems = ${core_elems}
    A = ${core_A_pipe}
    D_h = ${core_dia}
    initial_vel = ${core_inv}
  []
  [core12]
    type = FlowChannel1Phase
    position = '0.020 0.03464 0'
    orientation = '0 0 1'
    length = ${core_length}
    n_elems = ${core_elems}
    A = ${core_A_pipe}
    D_h = ${core_dia}
    initial_vel = ${core_inv}
  []
  [jct1]
    type = VolumeJunction1Phase
    position = '0 0 0'
    connections = 'up_pipe_1:out core1:in core2:in core3:in core4:in core5:in core6:in core7:in core8:in core9:in core10:in core11:in core12:in'
    volume = ${vol}
  []
  [up_pipe_2]
    type = FlowChannel1Phase
    position = '0 0 0.55'
    orientation = '0 0 1'
    length = 0.5
    n_elems = 25
    A = ${A_pipe}
    D_h = ${pipe_dia}
  []
  [jct2]
    type =VolumeJunction1Phase
    position = '0 0 0.55'
    connections = 'core1:out core2:out core3:out core4:out core5:out core6:out core7:out core8:out core9:out core10:out core11:out core12:out up_pipe_2:in'
    volume = ${vol}
  []
  [jct3]
    type =VolumeJunction1Phase
    position = '0 0 1.05'
    volume = ${vol}
    connections = 'up_pipe_2:out top_pipe_1:in' 
  []
  [top_pipe_1]
    type = FlowChannel1Phase
    position = '0 0 1.05'
    orientation = '1 0 0'
    length = 0.5
    n_elems = 10
    A = ${A_pipe}
    D_h = ${pipe_dia}
  []
  [top_pipe_2]
    type = FlowChannel1Phase
    position = '0.5 0 1.05'
    orientation = '1 0 0'
    length = 0.5
    n_elems = 20
    A = ${A_pipe}
    D_h = ${pipe_dia}
  []
  [press_pipe]
    type = FlowChannel1Phase
    position = '0.5 0 1.05'
    orientation = '0 0 1 '
    length = 0.2
    n_elems = 5
    A = ${A_pipe}
    D_h = ${pipe_dia}
  []
  [jct4]
    type = VolumeJunction1Phase
    position = '0.5 0 1.05'
    volume = ${vol}
    connections = 'top_pipe_1:out top_pipe_2:in press_pipe:in'
    
  []
  [jct5]
    type = VolumeJunction1Phase
    position = '1 0 1.05'
    volume = ${vol}
    connections = 'top_pipe_2:out down_pipe_1:in '
  []
  [down_pipe_1]
    type = FlowChannel1Phase
    position = '1 0 1.05'
    orientation = '0 0 -1'
    length = 0.25
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
 [pump]
    type = Pump1Phase
    position = '0.5 0 -0.5'
    connections = 'bottom_1:out bottom_2:in'
    volume = ${vol}
    A_ref = ${A_pipe}
    head = 0
    initial_T = 300
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
  [jct9]
    type = VolumeJunction1Phase
    position = '0 0 -0.5'
    volume = ${vol}
    connections = 'bottom_2:out up_pipe_1:in'
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
      scale = 12
  []
  [ht_sec]
      type = HeatTransferFromHeatStructure1Phase
      hs = wall
      hs_side = outer
      flow_channel = sec
      P_hf = '${fparse 2 * pi * hx_radius_wall}' 
      scale = 12
  []
  [bc1]
    type = HeatTransferFromExternalAppTemperature1Phase
    flow_channel= core1 
    T_ext = T_w
    var_type = ELEMENTAL
  []
  [bc2]
    type = HeatTransferFromExternalAppTemperature1Phase
    flow_channel= core2
    T_ext = T_w
    var_type = ELEMENTAL
  []
  [bc3]
    type = HeatTransferFromExternalAppTemperature1Phase
    flow_channel= core3
    T_ext = T_w
    var_type = ELEMENTAL
  []
  [bc4]
    type = HeatTransferFromExternalAppTemperature1Phase
    flow_channel= core4
    T_ext = T_w
    var_type = ELEMENTAL
  []
  [bc5]
    type = HeatTransferFromExternalAppTemperature1Phase
    flow_channel= core5
    T_ext = T_w
    var_type = ELEMENTAL
  []
  [bc6]
    type = HeatTransferFromExternalAppTemperature1Phase
    flow_channel= core6
    T_ext = T_w
    var_type = ELEMENTAL
  []
  [bc7]
    type = HeatTransferFromExternalAppTemperature1Phase
    flow_channel= core7
    T_ext = T_w
    var_type = ELEMENTAL
  []
  [bc8]
    type = HeatTransferFromExternalAppTemperature1Phase
    flow_channel= core8
    T_ext = T_w
    var_type = ELEMENTAL
  []
  [bc9]
    type = HeatTransferFromExternalAppTemperature1Phase
    flow_channel= core9 
    T_ext = T_w
    var_type = ELEMENTAL
  []
  [bc10]
    type = HeatTransferFromExternalAppTemperature1Phase
    flow_channel= core10 
    T_ext = T_w
    var_type = ELEMENTAL
  []
  [bc11]
    type = HeatTransferFromExternalAppTemperature1Phase
    flow_channel= core11
    T_ext = T_w
    var_type = ELEMENTAL
  []
  [bc12]
    type = HeatTransferFromExternalAppTemperature1Phase
    flow_channel= core12
    T_ext = T_w
    var_type = ELEMENTAL
  []
[]
[ControlLogic]
  [set_point]
    type = GetFunctionValueControl
    function = ${m_dot_in}
  []
  [pid]
    type = PIDControl
    initial_value = 22.5
    set_point = set_point:value
    input = m_dot_pump
    K_p = 10
    K_i = 40
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
  [power_to_core]
    type = ADHeatRateConvection1Phase
    block = core1
    P_hf= '${fparse  pi * core_dia }'
    T_wall =T_w
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
  [power_to_coolant]
    type = ADHeatRateConvection1Phase
    block = pri
    P_hf=  '${fparse pi * hx_dia_inner }'
  []
[]
[Preconditioning]
  [pc]
    type = SMP
    full = true
  []
[]
[Executioner]
  type = Transient
  solve_type = PJFNK
  line_search = basic
  start_time = 0
  end_time =30
  dt = 0.001
  dtmin=1e-4
  petsc_options_iname = '-pc_type  -KSP_TYPE'
  petsc_options_value = 'lu   gmres'
  nl_rel_tol = 1e-5
  nl_abs_tol = 1e-8
  nl_max_its = 25
[]
[Outputs]
  exodus = true
  [console]
    type = Console
    max_rows = 1
outlier_variable_norms =false
  []
  
[]


  

    


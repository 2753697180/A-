[Mesh]
type = FileMesh
file = test_1hole.e
[]
[Variables]
  [temperature]
    family = LAGRANGE
    order = FIRST
    initial_condition = '300' # Start at room temperature
  []
[]
[Functions]
  [A_line]
    type = PiecewiseLinearFromVectorPostprocessor
    vectorpostprocessor_name = T_fluid_vpp   
    argument_column = z
    value_column = A
    component = z
  []
  [A_Z]
    type = ParsedFunction
    expression = '0.3+1*z'
  []
[]
[AuxVariables]
  [T_fluid]
    family = MONOMIAL
    order = CONSTANT
    initial_condition = '300'
  []
  [htcp]
    family = MONOMIAL
    order = CONSTANT
    initial_condition = '100'
  []
  [T_wall]
    family =  MONOMIAL
    order  =  CONSTANT
    initial_condition = '1'
  []
  [T_wall_user]
    family =  MONOMIAL
    order  =  CONSTANT
    initial_condition = '300'
  []
[]
[Kernels]
  [heat_conduction]
    type = ADHeatConduction
    variable =temperature
  []
  [heat_source]
    type = HeatSource
    variable = temperature
    function= A_Z
    block = '1'
  []
  [heat_conduction_time_derivative]
    type = ADHeatConductionTimeDerivative
    variable = temperature
  []
[]
[AuxKernels]
  [T_wall]
    type = ProjectionAux
    v = temperature
    variable = T_wall
    boundary = '2'
  [] 
  [used]
    type=SpatialUserObjectAux
    user_object = layered_average_T
    variable = T_wall_user
    boundary = '2'
  []
[]
[BCs]
  [heat_q]
    type = DirichletBC
    variable =temperature
    boundary = '1'#(outer boundary)
    value = 0 # (q)
  []
  [uo]
    type = CoupledConvectiveHeatFluxBC
    boundary = '2 ' #(inner hole boundary)
    variable = temperature
    htc = htcp
    T_infinity = 'T_fluid'
    alpha = '1.0'
    scale_factor = '1'
  []
[]
[Materials]
  [fuel_material]
    type = fuel
    block = '1'
    specific_heat = 100              # 应用于块 ID 为 1 的区域，即燃料区域
  []
[]
[UserObjects]
  [layered_average_htc]
    type = LayeredSideAverage
     boundary = '2'
    variable = htcp
    direction = Z
    num_layers = 25
  []
  [layered_average_T]
    type = LayeredSideAverage
     boundary = '2'
    variable = temperature
    direction = Z
    num_layers = 25
  []
  [layered_average_fluid]
    type = LayeredSideAverage
     boundary = '2'
    variable = T_fluid
    direction = Z
    num_layers = 25
  []
  [LayeredAverage_A]
    type = LayeredSideAverage
    boundary = '2'
    direction = Z
    variable = T_wall
    num_layers = 25
  []
[]
[MultiApps]
  [1D]
   # app_type = DOGAPP
    type = TransientMultiApp
    input_files = 'f_P.i'
    execute_on = ' INITIAL timestep_begin'
   sub_cycling = true

  []
[]
# the following block is used to transfer data between the 1D and 3D simulations
# the type of Variable and AuxVariable should be Monomial  constant with those in the 1D and 3D simulation input file
[Transfers]
  [T_fluid]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = 1D
    source_variable = T #  receive from variable name in the 1D app
    variable = T_fluid  # transfer to variable name in the 3D app
    from_blocks = core1
    to_boundaries = '2'
    search_value_conflicts = false
  []
  [htc]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = 1D
    source_variable = 'htc' # receive from variable name in the 1D app
    variable = 'htcp' # transfer to variable name in the 3D app
    from_blocks= core1
    to_boundaries='2'
    search_value_conflicts = false
  []
  [Tw]
    type = MultiAppGeneralFieldNearestLocationTransfer
    to_multi_app = 1D
    source_variable = 'T_wall_user' # transfer to variable name in the 1D app
    variable = 'T_w'  # receive from variable name in the 3D app
    to_blocks= core1
    from_boundaries='2'
    search_value_conflicts = false
    # execute_on = 'timestep_begin'
  []
[]
[Executioner]
  fixed_point_max_its = 10
  type = Transient
  start_time = 0.5
  end_time = 50
  dt = 0.01
  dtmin = 1e-4
  solve_type = PJFNK
  nl_abs_tol = 1e-8
  nl_rel_tol = 1e-5
  automatic_scaling = true
  petsc_options_iname = '-pc_type  -KSP_TYPE'
  petsc_options_value = 'lu   gmres'
  #steady_state_tolerance = 1e-5
  #steady_state_detection = false
[]
[Postprocessors]
  [avg_T_wall]
    type = SideAverageValue
    boundary = '2'
    variable = temperature
   # execute_on = 'timestep_begin'
  []
  [avg_T_fluid]
    type = SideAverageValue
    boundary = '2'
    variable = T_fluid
    #execute_on = 'timestep_begin'
  []
  [avg_htc]
    type = SideAverageValue
    boundary = '2'
    variable = htcp
  # execute_on = 'timestep_begin'
  []
  [q_t]
    type = ADConvectiveHeatTransferSideIntegral
    T_solid =T_wall_user
    boundary = '2'
    htc_var = htcp
    T_fluid_var = T_fluid
   #execute_on = 'timestep_begin'
  []
[]
[Outputs]
  exodus = true
  [csv]
    type = CSV
    execute_on = 'timestep_end'
  [] 
[]



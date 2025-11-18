# 这是一个简单的二维导热问题，来演示moose输入文件的编写
# 该问题的求解区域是一个边长为0.4m的正方形区域
# 左边界温度为500K，右边界温度为300K，上下边界为绝热边界
# 材料为石墨，热导率为100W/(m·K)
# 通过求解该问题，可以得到稳态温度场分布，结果文件为nb1_out.e，并通过后处理查看温度场结果，后处理用的是paraview。
#################################
#moose中心文件的基本结构包括以下几个部分：
# [Mesh]：定义计算域的网格信息    moose中自带了一些简单的网格生成器，我们后续更多会使用外部网格生成器生成复杂网格，比如cubit。
# [Variables]：定义求解的变量    Variables定义的是有限元求解的基本变量，比如温度、位移、压力等。
# [Kernels]：定义方程的弱形式     Kernels定义的是方程的弱形式，是求解器的核心部分，比如热传导方程、弹性力学方程等。
# [BCs]：定义边界条件            BCs定义的是边界条件，三类边界条件其实也是方程的弱形式的一部分。
# [Materials]：定义材料属性      Materials定义的是材料属性，比如密度、热导率、弹性模量等，shimo是我自定义的类。
# [Problem]：定义问题类型        一般就是FEProblem，表示有限元问题
# [Executioner]：定义求解器和求解参数  Executioner定义的是求解器的类型和求解参数，比如稳态求解、瞬态求解、非线性求解等。
# [Outputs]：定义输出结果的格式和内容   这里主要是定义输出结果的格式，比如exodus、csv等，以及输出的内容，比如变量、误差等。
##### moose输入文件的格式基本是固定的，每个大部分都用方括号括起来。紫色关键字
##### 每个大部分中又可以包含多个小部分，每个小部分也用方括号括起来。黄色关键字
##### 每个小部分中包含多个参数，每个参数用等号连接，参数名和参数值之间可以有空格。
##### 每个部分的结尾用[]表示，表示该部分的结束。
##### 其中每个大部分的名称都是固定的，比如Mesh、Variables、Kernels等。
##### 每个小部分的名称是可以自定义的，比如gmg、temperature等。
##### 除了Variables以外，其他部分形式都是类似的。
##### 每个小部分方括号内第一句都是type开头，type后面表示以及编译到opt可执行文件中的C++类的名称，moose自带了很多类，也可以自定义类。
##### 之后每一行都是参数名=参数值的形式，参数名是类中定义的参数，参数值是用户定义的值。
##### 具体每个类的参数可以参考moose自带的文档，或者者自定义类的代码注释。
##### 下面我们逐个部分进行介绍。
[Mesh]
  [gmg]
    type = GeneratedMeshGenerator # Can generate simple lines, rectangles and rectangular prisms
    dim =1               # Dimension of the mesh
    nx = 10                      # Number of elements in the x direction                     # Number of elements in the y direction
    xmax = 0.2
    xmin = 0               # Length of test chamber               # Test chamber radius
  []
[]
[Variables]         
  [temperature]   #这里定义了一个变量，名称为temperature
    family = LAGRANGE   #这里定义了变量的有限元空间，LAGRANGE表示拉格朗日空间，也叫有限元族/基函数。
    order = FIRST       #这里定义了变量的有限元阶数，FIRST表示一阶拉格朗日空间，也就是线性空间。
  []
[]
[Kernels]
  [heat_conduction] #这里定义了一个内核函数，名称为heat_conduction，表示离散好的热传导方程的弱形式。
    type = HeatConduction   #这里定义了内核函数的类型，ADHeatConduction表示自动微分热传导内核函数，是moose自带的类。
    variable = temperature  #这里定义了内核函数作用的变量，temperature表示作用在temperature变量上。
    #每个类都含有必须参数与可选参数，必须参数必须定义，可选参数可以不定义，使用默认值。
    #具体每个类的参数可以参考moose自带的文档，或者者自定义类的代码注释。（这里是重点）
    #方程离散的弱形式就是通过内核函数来实现的，内核函数是方程离散的核心，
    #并且弱形式方程中的每一项都需要一个内核函数来表示，边界项除外。
  []
[]
[BCs] #BCs定义的是边界条件，三类边界条件其实也是方程的弱形式的一部分，三类边界条件添加到方程中的方式不一样。
  [left]
    type = DirichletBC  #这个边界条件的类型是DirichletBC，表示狄利克雷边界条件，也叫第一类边界条件，就是直接给出变量的值。
    variable = temperature #在方程中的表现就是u=u0，在方程中就是直接将给出值赋予对应边界上的变量。
    boundary = left    #这里是写边界的名称，left表示左边界，这是一种默认命名，可以在cubit中自定义边界集合
    value = 500       
  []
  [right]
    type = DirichletBC
    variable = temperature
    boundary = right
    value = 300          
  []
[]
[Materials]     #这里是定义材料属性的部分
 [shimo]               
  type=shimo      #石墨是我自定义的类，见shimo.C
  block = '0'        #block='0'表示该材料属性应用于块ID为0的区域，即整个计算域，这也是默认命名，可以在cubit中自定义块ID
thermal_conductivity = 1#这里定义了材料的热导率属性，单位是W/(m·K)，shimo.C中给出了默认值60，不过也可以在这里覆盖默认值。
 []
[]
[Problem]
  type = FEProblem  #这里基本都是FEProblem，表示有限元问题
[]
[Preconditioning]
  [pc]
    type = SMP
    full = true
    solve_type = PJFNK
    trust_my_coupling = true
  []
[]
[Executioner]
  type = Steady        #这里定义了求解器的类型，Steady表示稳态求解
  solve_type = PJFNK  #这里定义了求解器的求解类型，PJFNK表示完全雅可比前条件化的牛顿法，是一种非线性求解方法
  petsc_options_iname = '-pc_type -pc_hypre_type' # PETSc option pairs with values below
  petsc_options_value = 'hypre boomeramg' #这里需要注意的是，petsc_options_iname和petsc_options_value是一一对应的。
                                      #petsc具体怎么设置可以参考PETSc的文档，常用的选项可以参考moose自带的文档。
#求解其他常用的参数还有：
  nl_rel_tol = 1e-8    #非线性求解的相对收敛容限
  nl_abs_tol = 1e-10   #非线性求解的绝对收敛容限
  nl_max_its = 25      #非线性求解的最大迭代次数   
#求解器是一个很大的模块，里面包括很多参数，petsc也包括了很多参数，这里不一一介绍，后续会结合具体问题进行介绍。
[]

[Outputs]
  #这里定义输出结果的格式和内容
  #常用的大概就是
  [csv]
    type = CSV
    file_base = nb1_out  #这里定义输出文件的名称，结果文件为nb1_out.csv
  []
  [exodus]
    type = Exodus # Output Exodus format
  append_date = true # 这里表示在输出文件名称后面添加日期时间，防止覆盖
  file_base = nb1_out #这里定义输出文件的名称，结果文件为nb1_out.e
  # Outputs can be controlled even further, see the documentation for details
  []
[]

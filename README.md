此程序在moose thm模块  可变面积1D欧拉流基础上，
关于引入外界面积阶跃的1D可变面积欧拉流程序，在原有方程中引入A_new,并用A_new来求解当前步通量，添加u*dA/dt来描写引入面积的变化致使保守变量的变化    
关键在于由压力场求解出的速度场，在连续性方程中是守恒的，即没有波状压力的出现。

moosethm模块见 ：
https://mooseframework.inl.gov/modules/thermal_hydraulics/index.html



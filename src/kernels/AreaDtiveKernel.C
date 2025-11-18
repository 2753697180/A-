//* This file is part of the MOOSE framework
//* https://mooseframework.inl.gov
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "AreaDtiveKernel.h"

registerMooseObject("dogApp", AreaDtiveKernel);

InputParameters
AreaDtiveKernel::validParams()
{
  InputParameters params = ADKernelValue::validParams();
  params.addClassDescription("The time derivative operator with the weak form of $(\\psi_i, "
                             "\\frac{\\partial u_h}{\\partial t})$.");
  params.addRequiredCoupledVar("A", "Cross-sectional Area");
  return params;
}

AreaDtiveKernel::AreaDtiveKernel(const InputParameters & parameters)
  : ADKernelValue(parameters),
    _newarea(getADMaterialProperty<Real>("new_area")) , 
    _u_old(_var.dofValuesOld()),
    _Anew(getADMaterialProperty<Real>("Anew"))
{
}

ADReal
AreaDtiveKernel::precomputeQpResidual()
{  ADReal re;
//if (_u_old[_qp]!=_u[_qp])
      re = _u_old[_qp]/_Anew[_qp]*  (_Anew[_qp]-_newarea[_qp])/_dt;
//else
return re;
}

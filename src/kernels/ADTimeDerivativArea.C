//* This file is part of the MOOSE framework
//* https://mooseframework.inl.gov
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "ADTimeDerivativArea.h"

registerMooseObject("dogApp", ADTimeDerivativArea);

InputParameters
ADTimeDerivativArea::validParams()
{
  InputParameters params = ADTimeKernelValue::validParams();
  params.addClassDescription("The time derivative operator with the weak form of $(\\psi_i, "
                             "\\frac{\\partial u_h}{\\partial t})$.");
  return params;
}
ADTimeDerivativArea::ADTimeDerivativArea(const InputParameters & parameters)
  : ADTimeKernelValue(parameters),
    _newarea(getADMaterialProperty<Real>("new_area")),
    _Anew(getADMaterialProperty<Real>("Anew")),
    _u_old(_var.dofValuesOld())
{
}

ADReal
ADTimeDerivativArea::precomputeQpResidual()
{ 
   return _u_dot[_qp]* (_Anew[_qp]/_newarea[_qp]);
} 

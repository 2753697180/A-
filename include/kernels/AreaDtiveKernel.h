//* This file is part of the MOOSE framework
//* https://mooseframework.inl.gov
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "ADKernelValue.h"

class AreaDtiveKernel : public ADKernelValue
{
public:
  static InputParameters validParams();

  AreaDtiveKernel(const InputParameters & parameters);

protected:
  virtual ADReal precomputeQpResidual() override;
  const ADMaterialProperty<Real> & _newarea;
  const VariableValue & _u_old;
  const ADMaterialProperty<Real> & _Anew;
}; 

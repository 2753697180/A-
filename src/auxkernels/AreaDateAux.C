//* This file is part of the MOOSE framework
//* https://mooseframework.inl.gov
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "AreaDateAux.h"

#include "metaphysicl/raw_type.h"

registerMooseObject("dogApp", AreaDateAux);

InputParameters
AreaDateAux::validParams()
{
  InputParameters params = AuxKernel::validParams();

  // Add a "coupling paramater" to get a variable from the input file.
  return params;
}

AreaDateAux::AreaDateAux(const InputParameters & parameters)
  : AuxKernel(parameters),
 _newarea(getADMaterialProperty<Real>("new_area"))
{
}

Real
AreaDateAux::computeValue()
{
  return MetaPhysicL::raw_value(_newarea[_qp]);
}

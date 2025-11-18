//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "newarea.h"
#include "Function.h"

registerMooseObject("dogApp", newarea);

InputParameters
newarea::validParams()
{
  InputParameters params = Material::validParams();

  // Parameter for radius of the spheres used to interpolate permeability.
  params.addRequiredCoupledVar("area", "Cross-sectional area");
  params.addRequiredCoupledVar("area_grad", "Gradient of cross-sectional area");
  params.addRequiredCoupledVar("A", "Cross-sectional Area");
  return params;
}

newarea::newarea(const InputParameters & parameters)
  : Material(parameters),
    // Get the parameters from the input file
    _area(adCoupledValue("area")),
    _area_grad(adCoupledGradient("area_grad")),
    _A(adCoupledValue("A")),
    // Declare two material properties by getting a reference from the MOOSE Material system
    _newarea(declareADProperty<Real>("new_area")), 
    _areagrad(declareADProperty<RealVectorValue>("new_area_grad")),
    _Anew(declareADProperty<Real>("Anew"))

{
}
void
newarea::computeQpProperties()
{
  _newarea[_qp] = _area[_qp]; 
  _areagrad[_qp] = _area_grad[_qp];
  _Anew[_qp] = _A[_qp];
}
  

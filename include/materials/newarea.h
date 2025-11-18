//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "Material.h"

/**
 * Material objects inherit from Material and override computeQpProperties.
 *
 * Their job is to declare properties for use by other objects in the
 * calculation such as Kernels and BoundaryConditions.
 */
class newarea : public Material
{
public:
  static InputParameters validParams();
   newarea(const InputParameters & parameters);

protected:
  /// Necessary override. This is where the values of the properties are computed.
  virtual void computeQpProperties() override;

  /// The radius of the spheres in the column
  const ADVariableValue & _area;
  const ADVariableGradient & _area_grad;
  const ADVariableValue & _A;
/// The permeability (K) computed based on the radius (mm)
  ADMaterialProperty<Real> & _newarea;
  ADMaterialProperty<RealVectorValue> & _areagrad;
  ADMaterialProperty<Real> & _Anew;
  /// The viscosity of the fluid (mu)


  
};

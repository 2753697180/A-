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
class shimo : public Material
{
public:
  static InputParameters validParams();

  shimo (const InputParameters & parameters);

protected:
  /// Necessary override. This is where the values of the properties are computed.
  virtual void computeQpProperties() override;

  /// The radius of the spheres in the column
  const Real & _input_density;
  /// Value of viscosity from the input file
  const Real & _input_thermal_conductivity;
  const Real & _input_specific_heat;

//从材料中获得的属性
  MaterialProperty<Real> & _density;
  MaterialProperty<Real> & _thermal_conductivity;
  MaterialProperty<Real> & _specific_heat;

};

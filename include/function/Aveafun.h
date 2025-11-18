//* This file is part of the MOOSE framework
//* https://mooseframework.inl.gov
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "PiecewiseLinearBase.h"
#include "GeneralUserObject.h"

/**
 * Function which provides a piecewise continuous linear interpolation
 * of a provided (x,y) point data set.
 */
class Aveafun : public     PiecewiseLinearBase
{public:
  static InputParameters validParams();

  Aveafun(const InputParameters & parameters);

  /// Needed to process data from user objects that are not available at construction
  void initialSetup() override;
protected:
  const Real & _length;
  const unsigned & _num;
  const UserObject & _uo;
};

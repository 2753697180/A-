//* This file is part of the MOOSE framework
//* https://mooseframework.inl.gov
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "Aveafun.h"
#include "UserObjectInterface.h"
#include "UserObject.h"
registerMooseObject("dogApp", Aveafun);
InputParameters
Aveafun::validParams()
{
  InputParameters params = PiecewiseLinearBase::validParams();
  params.addParam<bool>(
      "extrap", false, "If true, extrapolates when sample point is outside of abscissa range");
  params.addClassDescription("Linearly interpolates between pairs of x-y data");
  //params.addCoupledVar("y_var", "Y variable to use for interpolation");
  params.addParam<Real>("length",0.5 ,"Y variable to use for interpolation");
  params.addParam<Real>("num",25, "Y variable to use for interpolation");
    params.addRequiredParam<UserObjectName>(
      "uo",
      "为什么");
  return params;
}

Aveafun::Aveafun(const InputParameters & parameters)
  : PiecewiseLinearBase(parameters), 
  _length(getParam<Real>("length")),
  _num(getParam<Real>("num")),
  //_y_var(CoupledName("y_var")) ,
  _uo(getUserObjectBase("uo"))
{
}

void
Aveafun::initialSetup()
{
  Real dx = _length/_num;
_raw_x.clear();
_raw_y.clear();
  for (unsigned int i=0; i<static_cast<unsigned int>(_num);i++)
    {_raw_x.push_back((i+0.5)*dx);
    std::cout<<_raw_x[i]<<std::endl;} 
  for (unsigned int i=0; i<_num; i++)
  {
    _raw_y.push_back(_uo.spatialValue((0,0,(_raw_x[i]))));
    std::cout<<_raw_y[i]<<std::endl;
  }
  this->buildInterpolation(this->template getParam<bool>("extrap"));
}

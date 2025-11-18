//* This file is part of the MOOSE framework
//* https://mooseframework.inl.gov
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#include "dogTestApp.h"
#include "dogApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "MooseSyntax.h"

InputParameters
dogTestApp::validParams()
{
  InputParameters params = dogApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  params.set<bool>("use_legacy_initial_residual_evaluation_behavior") = false;
  return params;
}

dogTestApp::dogTestApp(const InputParameters & parameters) : MooseApp(parameters)
{
  dogTestApp::registerAll(
      _factory, _action_factory, _syntax, getParam<bool>("allow_test_objects"));
}

dogTestApp::~dogTestApp() {}

void
dogTestApp::registerAll(Factory & f, ActionFactory & af, Syntax & s, bool use_test_objs)
{
  dogApp::registerAll(f, af, s);
  if (use_test_objs)
  {
    Registry::registerObjectsTo(f, {"dogTestApp"});
    Registry::registerActionsTo(af, {"dogTestApp"});
  }
}

void
dogTestApp::registerApps()
{
  registerApp(dogApp);
  registerApp(dogTestApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
// External entry point for dynamic application loading
extern "C" void
dogTestApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  dogTestApp::registerAll(f, af, s);
}
extern "C" void
dogTestApp__registerApps()
{
  dogTestApp::registerApps();
}

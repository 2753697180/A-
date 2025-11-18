#include "dogApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

InputParameters
dogApp::validParams()
{
  InputParameters params = MooseApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  params.set<bool>("use_legacy_initial_residual_evaluation_behavior") = false;
  return params;
}

dogApp::dogApp(const InputParameters & parameters) : MooseApp(parameters)
{
  dogApp::registerAll(_factory, _action_factory, _syntax);
}

dogApp::~dogApp() {}

void
dogApp::registerAll(Factory & f, ActionFactory & af, Syntax & syntax)
{
  ModulesApp::registerAllObjects<dogApp>(f, af, syntax);
  Registry::registerObjectsTo(f, {"dogApp"});
  Registry::registerActionsTo(af, {"dogApp"});

  /* register custom execute flags, action syntax, etc. here */
}

void
dogApp::registerApps()
{
  registerApp(dogApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
dogApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  dogApp::registerAll(f, af, s);
}
extern "C" void
dogApp__registerApps()
{
  dogApp::registerApps();
}

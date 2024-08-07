{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  flit-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "entrypoints";
  version = "0.4";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-twbt2qkhihnrzWe1aBjwW7J1ibHKno15e3Sv+tTMrNQ=";
  };

  nativeBuildInputs = [ flit-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Discover and load entry points from installed packages";
    homepage = "https://github.com/takluyver/entrypoints";
    license = licenses.mit;
    maintainers = [ ];
  };
}

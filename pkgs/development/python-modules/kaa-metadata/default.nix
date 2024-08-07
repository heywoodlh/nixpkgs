{
  lib,
  buildPythonPackage,
  fetchPypi,
  kaa-base,
  isPyPy,
  isPy3k,
  python,
  pkgs,
}:

buildPythonPackage rec {
  version = "0.7.8dev-r4569-20111003";
  format = "setuptools";
  pname = "kaa-metadata";
  disabled = isPyPy || isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0bkbzfgxvmby8lvzkqjp86anxvv3vjd9nksv2g4l7shsk1n7y27a";
  };

  doCheck = false;

  buildInputs = [ pkgs.libdvdread ];

  propagatedBuildInputs = [ kaa-base ];

  # Same as in buildPythonPackage except that it does not pass --old-and-unmanageable
  installPhase = ''
    runHook preInstall

    mkdir -p "$out/${python.sitePackages}"

    export PYTHONPATH="$out/${python.sitePackages}:$PYTHONPATH"

    ${python}/bin/${python.executable} setup.py install \
      --install-lib=$out/${python.sitePackages} \
      --prefix="$out"

    eapth="$out/${python.sitePackages}/easy-install.pth"
    if [ -e "$eapth" ]; then
    mv "$eapth" $(dirname "$eapth")/${pname}-${version}.pth
    fi

    rm -f "$out/${python.sitePackages}"/site.py*

    runHook postInstall
  '';

  meta = with lib; {
    description = "Python library for parsing media metadata, which can extract metadata (e.g., such as id3 tags) from a wide range of media files";
    homepage = "https://github.com/freevo/kaa-metadata";
    license = licenses.gpl2;
    maintainers = [ ];
  };
}

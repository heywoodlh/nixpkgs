{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "butane";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "coreos";
    repo = "butane";
    rev = "v${version}";
    hash = "sha256-xb5CDuwGpYJgnG0KzlvkzTyeqo1d2fUcXh0a2hbCEd0=";
  };

  vendorHash = null;

  doCheck = false;

  subPackages = [ "internal" ];

  ldflags = [
    "-X github.com/coreos/butane/internal/version.Raw=v${version}"
  ];

  postInstall = ''
    mv $out/bin/{internal,butane}
  '';

  meta = with lib; {
    description = "Translates human-readable Butane configs into machine-readable Ignition configs";
    mainProgram = "butane";
    license = licenses.asl20;
    homepage = "https://github.com/coreos/butane";
    maintainers = with maintainers; [
      elijahcaine
      ruuda
    ];
  };
}

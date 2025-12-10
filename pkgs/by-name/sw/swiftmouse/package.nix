{
  lib,
  rustPlatform,
  fetchFromGitHub,
  runCommand,
  swiftmouse,
  pkg-config,
  pipewire,
  alsa-lib,
  llvmPackages,
}:

let
  # https://github.com/quexten/swiftmouse/issues/8#issuecomment-2466477155
  scap = rustPlatform.buildRustPackage (finalAttrs: {
    pname = "scap";
    version = "0.0.6";

    src = fetchFromGitHub {
      owner = "CapSoftware";
      repo = "scap";
      rev = "v${finalAttrs.version}";
      hash = "sha256-cZHNz8kqx6LkUcKhQf8XGUAusZxAKw7Bfx4hoRGSxfU=";
    };

    cargoHash = "sha256-DOJI2zQ+8szdLdId2+CK/SKKe6dC21ss+0nyEFhBAYY=";
  });
in rustPlatform.buildRustPackage (finalAttrs: {
  pname = "swiftmouse";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "quexten";
    repo = "swiftmouse";
    rev = finalAttrs.version;
    hash = "sha256-0mjXi+hkwgEn5xm4gWEIEifpFG2G9PhvS3a65DUOJvI=";
  };

  env.LIBCLANG_PATH = "${lib.getLib llvmPackages.clang-unwrapped.lib}/lib";

  buildInputs = [
    pipewire
    alsa-lib
  ];

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    scap
  ];

  cargoHash = "sha256-KUSivUCBMxcfSviuRom+ZrztPeLXHemw6a7HhoeG9TI=";

  passthru = {
    tests.simple = runCommand "${finalAttrs.pname}-test" { } ''
      mkdir -p $out
      ${swiftmouse}/bin/thing --version
    '';
  };

  meta = with lib; {
    description = "Shortcat like app for keyboard-based mouse navigation on Linux";
    homepage = "https://github.com/quexten/swiftmouse";
    maintainers = [ maintainers.heywoodlh ];
    platforms = platforms.linux;
    mainProgram = "daemon";
  };
})


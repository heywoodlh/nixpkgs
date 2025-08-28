{
  lib,
  stdenv,
  fetchFromGitHub,
  runCommand,
  vicinae,
  cmake,
  qt6,
  qt6Packages,
  kdePackages,
  ninja,
  openssl,
  protobuf,
  libqalculate,
  cmark-gfm,
  minizip,
}:

stdenv.mkDerivation (finalAttrs: {
  name = "vicinae";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "vicinaehq";
    repo = "vicinae";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-OMMZNfYqQUMpvMVrcQpqFf+u1FlSqOihk5G4dvTNocU=";
  };

  env = {
    OPENSSL_DIR = lib.getDev openssl;
    OPENSSL_LIB_DIR = "${lib.getLib openssl}/lib";
    OPENSSL_NO_VENDOR = 1;
  };

  nativeBuildInputs = [
    cmake
    qt6.full
    ninja
    libqalculate
    cmark-gfm
    minizip
  ];

  buildInputs = [
    qt6Packages.qtkeychain
    qt6Packages.qtwayland
    kdePackages.layer-shell-qt
    protobuf
    openssl
  ];

  phases = [
    "buildPhase"
    "installPhase"
    "fixupPhase"
  ];

  buildPhase = ''
    runHook preBuild
    cmake -G Ninja -B build -S ${finalAttrs.src} \
      -DQt6Keychain_DIR=${lib.getDev qt6Packages.qtkeychain}/lib/cmake/Qt6Keychain \
      -DQt6WaylandClient_DIR=${lib.getDev qt6Packages.qtwayland}/lib/cmake/Qt6WaylandClient \
      -DTYPESCRIPT_EXTENSIONS=OFF \
      -DCMAKE_INSTALL_PREFIX=$out
    cmake --build build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    cmake --install build ${finalAttrs.src}
    runHook postInstall
  '';

  passthru = {
    tests = {
      exec = runCommand "${finalAttrs.name}-test" { } ''
        ${vicinae}/bin/vicinae --version
      '';
    };
  };

  meta = {
    changelog = "https://github.com/vicinaehq/vicinae/releases/tag/v${finalAttrs.version}";
    description = "Focused launcher for your desktop — native, fast, extensible";
    homepage = "https://docs.vicinae.com/";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ heywoodlh ];
    mainProgram = "vicinae";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})


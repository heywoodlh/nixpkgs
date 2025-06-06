{
  lib,
  stdenv,
  fetchFromGitHub,
  replaceVars,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook3,
  desktop-file-utils,
  libcanberra,
  gst_all_1,
  vala,
  gtk3,
  gom,
  sqlite,
  libxml2,
  glib,
  gobject-introspection,
  json-glib,
  libpeas,
  gsettings-desktop-schemas,
  gettext,
}:
stdenv.mkDerivation rec {
  pname = "gnome-pomodoro";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "gnome-pomodoro";
    repo = "gnome-pomodoro";
    rev = version;
    hash = "sha256-ZdTMaCzjA7tsXmnlHGl8MFGGViVPwMZuiu91q5v/v9U=";
  };

  patches = [
    # Our glib setup hooks moves GSettings schemas to a subdirectory to prevent conflicts.
    # We need to patch the build script so that the extension can find them.
    (replaceVars ./fix-schema-path.patch {
      inherit pname version;
    })
  ];

  # Manually compile schemas for package since meson option
  # gnome.post_install(glib_compile_schemas) used by package tries to compile in
  # the wrong dir.
  preFixup = ''
    glib-compile-schemas ${glib.makeSchemaPath "$out" "${pname}-${version}"}
  '';

  nativeBuildInputs = [
    meson
    ninja
    gettext
    gobject-introspection
    libxml2
    pkg-config
    vala
    wrapGAppsHook3
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gom
    gsettings-desktop-schemas
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gstreamer
    gtk3
    json-glib
    libcanberra
    libpeas
    sqlite
  ];

  meta = with lib; {
    homepage = "https://gnomepomodoro.org/";
    description = "Time management utility for GNOME based on the pomodoro technique";
    mainProgram = "gnome-pomodoro";
    longDescription = ''
      This GNOME utility helps to manage time according to Pomodoro Technique.
      It intends to improve productivity and focus by taking short breaks.
    '';
    maintainers = with maintainers; [
      aleksana
      herschenglime
    ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}

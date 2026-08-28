{
  fetchFromGitHub,
  glib,
  gtk4,
  lib,
  libadwaita,
  pkg-config,
  rustPlatform,
  writeText,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "aml-flash-tool";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "antoxa78";
    repo = "Amlogic-Tool-for-Linux";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Us0nc6hLxF9fT4T9xesHnElBg26OaNBIOZhZUgkfV80=";
  };

  cargoHash = "sha256-1OiAxx6SP9F6QYp+0tLnlGQlnOxDk19W6E14dfyY4NQ=";

  nativeBuildInputs = [
    glib
    pkg-config
  ];

  buildInputs = [
    gtk4
    libadwaita
  ];

  udevRules = writeText "99-amlogic-flash.rules" ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="1b8e", MODE="0660", GROUP="amlusers"
  '';

  postInstall = ''
    install -Dm 0644 ${lib.escapeShellArg finalAttrs.udevRules} \
      "$out/lib/udev/rules.d/99-amlogic-flash.rules"
    install -Dm 0644 assets/aml-flash-tool.png \
      "$out/share/icons/hicolor/1024x1024/apps/"${lib.escapeShellArg finalAttrs.pname}.png
    install -Dm 0644 assets/aml-flash-tool.desktop \
      "$out/share/applications/"${lib.escapeShellArg finalAttrs.pname}.desktop
  '';

  meta.mainProgram = finalAttrs.pname;
})

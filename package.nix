{
  fetchFromGitHub,
  glib,
  gtk4,
  lib,
  libadwaita,
  pkg-config,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "aml-flash-tool";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "antoxa78";
    repo = "Amlogic-Tool-for-Linux";
    tag = finalAttrs.version;
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

  postInstall = ''
    install -Dm 0644 ${
      lib.escapeShellArg (finalAttrs.src + "/assets/99-amlogic-flash.rules")
    } "$out/lib/udev/rules.d/99-amlogic-flash.rules"
  '';

  meta.mainProgram = finalAttrs.pname;
})

{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  copyDesktopItems,
  makeWrapper,
  makeDesktopItem,
  nodejs_22,
  electron_40,
  nodejs ? nodejs_22,
  electron ? electron_40,
}:
buildNpmPackage (finalAttrs: {
  inherit nodejs;

  pname = "openscreen";
  version = "1.3.0-unstable-2025-04-04";

  src = fetchFromGitHub {
    owner = "siddharthvaddem";
    repo = "openscreen";
    rev = "763c187f871de4be7e598bf2e7c35205b4b59e44";
    hash = "sha256-fFycaYQwDJ2IMq7J1+9m0mFiuMdO8RYp10f/8GatHLs=";
  };

  npmDepsHash = "sha256-V8FzrniM2iXddS6ZvphHAu88N534udFzbVP4FnNvBSw=";

  npmRebuildFlags = [ "--ignore-scripts" ];

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  buildPhase = ''
    runHook preBuild

    npm exec tsc
    npm exec vite build

    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      # electronDist needs to be modifiable on Darwin
      cp -r ${electron.dist} electron-dist
      chmod -R u+w electron-dist

      npm exec electron-builder -- \
        --dir \
        -c.electronDist=electron-dist \
        -c.electronVersion=${electron.version} \
        -c.mac.identity=null
    ''}
    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      npm exec electron-builder -- \
        --dir \
        -c.electronDist=${electron.dist} \
        -c.electronVersion=${electron.version}
    ''}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      mkdir -p $out/share/openscreen
      cp -r release/*/*-unpacked/{locales,resources{,.pak}} $out/share/openscreen

      makeWrapper ${lib.getExe electron} $out/bin/openscreen \
          --add-flags $out/share/openscreen/resources/app.asar \
          --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
          --set-default ELECTRON_IS_DEV 0 \
          --inherit-argv0

      install -Dm644 icons/icons/png/512x512.png $out/share/icons/hicolor/512x512/apps/openscreen.png
    ''}

    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/Applications
      cp -R release/*/mac*/Openscreen.app $out/Applications/
      makeWrapper $out/Applications/Openscreen.app/Contents/MacOS/Openscreen $out/bin/openscreen
    ''}

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "openscreen";
      desktopName = "OpenScreen";
      comment = finalAttrs.meta.description;
      icon = "openscreen";
      exec = "openscreen %u";
      categories = [
        "AudioVideo"
        "Video"
        "Utility"
      ];
      terminal = false;
    })
  ];

  meta = {
    description = "Free, open-source alternative to Screen Studio (sort of)";
    homepage = "https://openscreen.vercel.app";
    license = lib.licenses.mit;
    mainProgram = "openscreen";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})

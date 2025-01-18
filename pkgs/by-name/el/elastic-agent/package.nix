{
  lib,
  fetchFromGitHub,
  buildGoModule,
  mage,
  gotestsum,
  writeShellScriptBin,
}:

buildGoModule rec {
  pname = "elastic-agent";
  version = "8.17.0";

  src = fetchFromGitHub {
    owner = "elastic";
    repo = "elastic-agent";
    rev = "v${version}";
    hash = "sha256-0y4321/BnkSLyYGUuZ79e9pJI0Fy5IhwPZzJpsYcyXo=";
  };

  nativeBuildInputs =
    let
      fakeGit = writeShellScriptBin "git" ''
        if [[ $@ = "rev-parse HEAD" ]]; then
            echo "${version}"
        else
            >&2 echo "Unknown command: $@"
            exit
        fi
      '';
    in
    [
      fakeGit
      mage
    ];

  nativeCheckInputs = [ gotestsum ];

  vendorHash = "sha256-pzAFiC4xSSgNsKjpXjQwxsfso6RZ9ULoPiujAqVXHcI=";

  patches = [
    ./gotest.patch
  ];

  ldflags = [
    "-X main.Commit=${version}"
    "-X main.version=${version}"
    "-X main.builtBy=nixpkgs"
  ];

  buildPhase = ''
    runHook prebuild

    # Fixes "mkdir /homeless-shelter: permission denied" - "Error: error compiling magefiles" during build
    export HOME=$(mktemp -d)
    mage build:binaryOSS

    runHook postBuild
  '';

  # Todo: Add tests...
  checkPhase = ''
  '';

  installPhase = ''
    runHook preInstall
    install -Dt $out/bin/elastic-agent-oss build/elastic-agent-oss
    install -Dt $out/etc/elastic-agent.yml build/elastic-agent.yml
    runHook postInstall
  '';

  meta = with lib; {
    description = "A single, unified way to add monitoring for logs, metrics, and other types of data to a host";
    homepage = "https://www.elastic.co/elastic-agent";
    license = licenses.elastic20;
    maintainers = with lib.maintainers; [ bstanderline ];
  };
}

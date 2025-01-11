{
  lib,
  fetchFromGitHub,
  buildGoModule,
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

  vendorHash = "sha256-pzAFiC4xSSgNsKjpXjQwxsfso6RZ9ULoPiujAqVXHcI=";

  meta = with lib; {
    description = "A single, unified way to add monitoring for logs, metrics, and other types of data to a host";
    homepage = "https://www.elastic.co/elastic-agent";
    license = licenses.elastic20;
    maintainers = with lib.maintainers; [ bstanderline ];
  };
}

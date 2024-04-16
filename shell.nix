let
  sources = import ./npins;
  pkgs = import sources.nixpkgs-unstable { };
  agenix = pkgs.callPackage "${sources.agenix}/pkgs/agenix.nix" { };
in
pkgs.mkShell {
  packages = with pkgs; [
    colmena
    agenix
    nixfmt-rfc-style
    npins
    (octodns.withProviders (
      ps: with python3Packages; [
        octodns-providers.bind
        (buildPythonPackage rec {
          pname = "octodns-gcore";
          version = "0.0.5-unstable";
          pyproject = true;

          src = fetchFromGitHub {
            owner = "octodns";
            repo = "octodns-gcore";
            rev = "84ce0854a9a27cee9a00cae62049c402eb47c719";
            hash = "sha256-v+NLsBSoTRUB35sxeF824v6uOcWK8/pCZTc9k3NH50A=";
          };

          nativeBuildInputs = [ setuptools ];

          propagatedBuildInputs = [
            octodns
            requests
          ];

          pythonImportsCheck = [ "octodns_gcore" ];
          nativeCheckInputs = [
            pytestCheckHook
            requests-mock
          ];

          meta = with lib; {
            description = "GCore DNS provider for octoDNS";
            homepage = "https://github.com/octodns/octodns-gcore/";
            changelog = "https://github.com/octodns/octodns-gcore/blob/${src.rev}/CHANGELOG.md";
            license = licenses.mit;
          };
        })
      ]
    ))
  ];
}

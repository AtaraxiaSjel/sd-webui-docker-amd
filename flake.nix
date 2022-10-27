{
  inputs = {
    flake-utils-plus.url = "github:gytis-ivaskevicius/flake-utils-plus";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, flake-utils-plus, ... }@inputs:
  let
    pkgs-unstable = self.channels.unstable;
  in flake-utils-plus.lib.mkFlake {
    inherit self inputs;
    channels.unstable.input = nixpkgs;

    outputsBuilder = channels: let
      pkgs = channels.unstable;
      image-tag = "ataraxiadev/rocm-pytorch:latest";
      cmd-line-options = "/shared/init.sh --theme dark --listen --port 7860 --deepdanbooru --medvram --opt-split-attention";
    in rec {
      packages = {
        image-build = pkgs.writeShellScriptBin "image-build" ''
          docker build --force-rm --tag ${image-tag} "$@" .
        '';
        image-run = pkgs.writeShellScriptBin "image-run" ''
          docker run -it --rm --name stable-diffusion --device=/dev/kfd --device=/dev/dri --group-add=video --ipc=host --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -p 80:7860 -v $(pwd)/shared:/shared ${image-tag} ${cmd-line-options} "$@"
        '';
      };
      defaultPackage = packages.image-run;
      devShell = pkgs.mkShell {
        name = "pytorch-terminal";
        packages = with packages; [ image-build image-run ];
      };
    };
  };
}

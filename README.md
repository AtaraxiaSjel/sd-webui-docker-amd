# Stable-Diffusion-WebUI (AUROMATIC1111) docker image for AMD GPUs

Contains init script (./shared/init.sh) that downloads the NAI model, hypernetworks, danbooru tag autocomplition and some sane ui-config defaults.

1. Clone this repository (optional)
2. Run docker container. For example:

```bash
docker run -it --rm --name stable-diffusion --device=/dev/kfd --device=/dev/dri --group-add=video --ipc=host --cap-add=SYS_PTRACE --security-opt seccomp=unconfined --port 80:7860 -v $(pwd)/shared:/shared ataraxiadev/rocm-pytorch /shared/init.sh --theme dark --listen --port 7860 --deepdanbooru
```

Nixos users can clone this repository and run:

```bash
nix run
```

or

```bash
nix develop
image-run
```

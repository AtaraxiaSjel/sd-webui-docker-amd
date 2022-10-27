#!/bin/bash
cd /shared
if [ ! -d "stable-diffusion-webui" ]; then
    git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git stable-diffusion-webui
    cd stable-diffusion-webui
    # Download NAI model
    gdown --folder -O nai 1IM63Lef1lEPwUbSdVtdHn_VVT4DaKX6u
    mv nai/nai.ckpt ./models/Stable-diffusion
    mv nai/nai.vae.pt ./models/Stable-diffusion
    mv nai/nai.yaml ./models/Stable-diffusion
    mv nai/v2.pt ./
    mv nai/v2enable.py ./scripts
    # Download hypernetworks
    unzip nai/hypernetworks.zip -d ./models
    rm -f nai/hypernetworks.zip
    rmdir nai
    # Install danbooru tag auto-complition and sane nai defaults
    git clone https://github.com/DominikDoom/a1111-sd-webui-tagcomplete /tmp/tagcomplete
    cp -r /tmp/tagcomplete/javascript /shared/stable-diffusion-webui/
    cp -r /tmp/tagcomplete/tags /shared/stable-diffusion-webui/
    cp -r /tmp/tagcomplete/scripts /shared/stable-diffusion-webui/
    rm -rf /tmp/*
    wget https://gist.githubusercontent.com/AlukardBF/27c27f7982b2cdaafa3badd082d061c5/raw/eb95d63caaa1a7c108f8d5d0ed6913f47506a1d5/ui-config.js -O /shared/stable-diffusion-webui/ui-config.json
    wget https://gist.githubusercontent.com/AlukardBF/66d6450047dfa8e1f53b7586152497ff/raw/830f0c5201251eb7f8164609a404e38d9c049bc0/config.json -O /shared/stable-diffusion-webui/config.json
    # History tab extension
	mkdir -p extensions
	git clone https://github.com/yfszzx/stable-diffusion-webui-images-browser extensions/images-browser

    python3 -m venv --system-site-packages venv
    source venv/bin/activate
    pip install --upgrade pip
    # workaround this issue: https://github.com/AUTOMATIC1111/stable-diffusion-webui/issues/2858
    sed -i -E "s#gradio.*#gradio==3.4.1#" requirements_versions.txt
else
    cd /shared/stable-diffusion-webui
    git restore requirements_versions.txt
    git pull
    sed -i -E "s#gradio.*#gradio==3.4.1#" requirements_versions.txt
    source venv/bin/activate
    pip install --upgrade pip
fi
export REQS_FILE=requirements_versions.txt
python3 launch.py "$@"

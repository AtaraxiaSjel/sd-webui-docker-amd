FROM greyltc/archlinux-aur:yay

ARG UID=1000
ARG GID=100
ARG UNAME=rocm
# import keys
RUN pacman-key --init && pacman -Syu --noconfirm \
    && curl -O https://mirrors.tuna.tsinghua.edu.cn/arch4edu/any/arch4edu-keyring-20200805-1-any.pkg.tar.zst \
    && pacman -U arch4edu-keyring-20200805-1-any.pkg.tar.zst --noconfirm \
    && rm -f arch4edu-keyring-20200805-1-any.pkg.tar.zst \
    && pacman-key --recv-keys 7931B6D628C8D3BA && pacman-key --finger 7931B6D628C8D3BA && pacman-key --lsign-key 7931B6D628C8D3BA \
    && printf "[arch4edu]\nServer = https://mirror.lesviallon.fr/arch4edu/\$arch" >> /etc/pacman.conf \
    && pacman -Syu --noconfirm && pacman-db-upgrade

# install rocm, pytoch, torchvision
RUN aur-install python-pytorch-rocm python-torchvision git unzip wget nano gdown

# create user and work directory
RUN groupadd -g $GID -o $UNAME \
    && useradd -m -u $UID -g $GID -o -G wheel,video -s /bin/bash $UNAME \
    && echo "$UNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
    && mkdir /shared && chown $UID:$GID /shared

USER $UNAME
WORKDIR /shared
ENV PATH "${PATH}:/opt/rocm/bin"
ENV TRANSFORMERS_CACHE "/shared/.transformers-cache"
CMD [ "bash", "-l" ]
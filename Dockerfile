FROM ubuntu:24.04

ENV TZ=Asia/Tokyo
ENV LANG=ja_JP.UTF-8
ENV LC_ALL=ja_JP.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    file \
    git \
    locales \
    procps \
    python-is-python3 \
    sudo \
    unzip \
    vim \
    zsh \
    && locale-gen ja_JP.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN if id -u $USER_UID >/dev/null 2>&1; then userdel -r $(id -un $USER_UID); fi \
    && if getent group $USER_GID >/dev/null 2>&1; then groupdel $(getent group $USER_GID | cut -d: -f1); fi \
    && groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo "$USERNAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME

COPY --chown=$USERNAME:$USERNAME . /home/$USERNAME/dotfiles
WORKDIR /home/$USERNAME/dotfiles
RUN make link

WORKDIR /home/$USERNAME

USER root
RUN chsh -s $(which zsh) $USERNAME
USER $USERNAME

RUN zsh -c "source ~/.zshenv && source ~/.config/zsh/.zshrc" || true

RUN NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
ENV PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:${PATH}"

RUN brew install \
    bat \
    delta \
    direnv \
    eza \
    fd \
    fzf \
    gh \
    ghq \
    neovim \
    tmux

RUN nvim --headless "+Lazy! sync" +qa || true

USER root
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf aws awscliv2.zip
USER $USERNAME

RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-x86_64.tar.gz \
    && tar -xf google-cloud-cli-linux-x86_64.tar.gz \
    && ./google-cloud-sdk/install.sh --quiet --path-update=false \
    && rm google-cloud-cli-linux-x86_64.tar.gz
ENV PATH="/home/$USERNAME/google-cloud-sdk/bin:${PATH}"

SHELL ["/bin/zsh", "-c"]
CMD ["/bin/zsh", "-l"]

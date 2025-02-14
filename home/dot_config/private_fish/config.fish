if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source
end

# homebrew-core
set -gx HOMEBREW_BREW_GIT_REMOTE "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
set -gx HOMEBREW_CORE_GIT_REMOTE "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
set -gx HOMEBREW_INSTALL_FROM_API 1
fish_add_path /home/linuxbrew/.linuxbrew/bin

# rust
set -gx RUSTUP_DIST_SERVER "https://mirrors.ustc.edu.cn/rust-static"
set -gx RUSTUP_UPDATE_ROOT "https://mirrors.ustc.edu.cn/rust-static/rustup"
fish_add_path $HOME/.cargo/bin

# usual
set -Ux FISH $HOME/.config/fish/
set -x STARSHIP_CONFIG ~/.config/starship.toml
fish_add_path /usr/local/bin /user/sbin
fish_add_path $HOME/bin

# OS wiget
set -Ux OSWidget $HOME/os-widget/

# Qemu 7
#set PATH $OSWiget/qemu-7.0.0/build $PATH
#set PATH $OSWiget/qemu-7.0.0/build/riscv64-softmmu $PATH
#set PATH $OSWiget/qemu-7.0.0/build/riscv64-linux-user $PATH

# musl
fish_add_path $OSWidget/x86_64-linux-musl-cross/bin \
    $OSWidget/aarch64-linux-musl-cross/bin \
    $OSWidget/riscv64-linux-musl-cross/bin

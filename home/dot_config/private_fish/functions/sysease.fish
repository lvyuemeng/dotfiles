function sysease
    if command -v apt
        sudo apt update && sudo apt upgrade -y
        sudo apt autoremove -y
        sudo apt clean
    else if command -v brew
        brew update
        brew upgrade
        brew cleanup
    end

    sudo journalctl --vacuum-time=3d
    sudo rm -rf /tm
end

function wttr -a in
    curl wttr.in/$in
end

abbr -ag ll 'ls -alh --color=auto'
abbr -ag gs 'git status'
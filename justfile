set shell := ["sh", "-eu", "-c"]

default:
    @just --list

install-local: install-config-local
    install -d "$HOME/.local/bin"
    install -m 755 linkmenu "$HOME/.local/bin/linkmenu"

install-global: install-config-local
    sudo install -d /usr/local/bin
    sudo install -m 755 linkmenu /usr/local/bin/linkmenu

install-config-local:
    install -d "${XDG_CONFIG_HOME:-$HOME/.config}/linkmenu"
    if [ ! -e "${XDG_CONFIG_HOME:-$HOME/.config}/linkmenu/linkmenu.conf" ]; then install -m 644 linkmenu.conf "${XDG_CONFIG_HOME:-$HOME/.config}/linkmenu/linkmenu.conf"; fi

# linkmenu

`linkmenu` loads bookmarks from a Linkding server through the REST API, shows them in a dmenu-compatible launcher, and then opens a second menu for the action: copy the link, open it in the browser, or type it with an input automation tool. The most recently fetched bookmarks are cached as JSON under `$XDG_CACHE_HOME/linkmenu/bookmarks.json` and reused when the server is unavailable.

## Requirements

- Python 3
- a dmenu-compatible launcher such as `dmenu` or `walker --dmenu`
- an input automation tool such as `xdotool` or `ydotool`
- an API token from your Linkding server

## Configuration

The script loads configuration from `$XDG_CONFIG_HOME/linkmenu/linkmenu.conf` by default. If `XDG_CONFIG_HOME` is unset, it falls back to `~/.config/linkmenu/linkmenu.conf`.
A different config path can be selected with `--config-file` or `LINKMENU_CONFIG_FILE`.

The config file uses simple `KEY=value` lines, for example:

```sh
LINKDING_URL=https://linkding.example.com
LINKDING_TOKEN=your-token
LINKMENU_LAUNCHER=walker --dmenu -p {prompt}
LINKMENU_OPEN=xdg-open
LINKMENU_COPY=wl-copy
LINKMENU_INPUTAUTOMATIONTOOL=ydotool type --file -
LINKMENU_COPY_ACTION_FIELD="copy"
LINKMENU_OPEN_URL_ACTION_FIELD="open"
LINKMENU_AUTOTYPE_ACTION_FIELD="type"
LINKMENU_CACHE_FILE=$HOME/.cache/linkmenu/bookmarks.json
```

Environment variables override the config file. CLI flags override environment variables and the config file.

`LINKMENU_LAUNCHER` must read from stdin and print the selected line to stdout. That is the usual behavior of `dmenu`, `walker --dmenu`, and similar launchers. If the command contains `{prompt}`, that placeholder is replaced with the default prompt for each menu.

`LINKMENU_OPEN` receives the URL as its last argument. Alternatively, the command may contain a `{url}` placeholder.

`LINKMENU_COPY` must read the text to copy from stdin. If `LINKMENU_COPY` is not set, the script automatically tries `wl-copy`, `xclip`, `xsel` and `pbcopy` in this order.

`LINKMENU_INPUTAUTOMATIONTOOL` must read the text to type from stdin.

`LINKMENU_COPY_ACTION_FIELD` sets the copy action field content.

`LINKMENU_OPEN_URL_ACTION_FIELD` sets the url opener action field content.

`LINKMENU_AUTOTYPE_ACTION_FIELD` sets the autotype action field content.

`LINKMENU_CACHE_FILE` overrides the default JSON cache path.

## Installation

Using `just`:

```sh
$ just install-local
$ sudo just install-global
```

`install-local` installs the script to `~/.local/bin/linkmenu` and writes `~/.config/linkmenu/linkmenu.conf` only if that config file does not already exist.

`install-global` installs the script to `/usr/local/bin/linkmenu` and still writes the config file only if `~/.config/linkmenu/linkmenu.conf` does not already exist.

## Usage

```sh
$ linkmenu -h
usage: linkmenu [-h] [--config-file CONFIG_FILE] [--server SERVER] [--token TOKEN] [--launcher LAUNCHER] [--inputautomation INPUTAUTOMATION] [--open-command OPEN_COMMAND] [--copy-command COPY_COMMAND] [--copy-action-field COPY_ACTION_FIELD] [--open-url-action-field OPEN_URL_ACTION_FIELD] [--autotype-action-field AUTOTYPE_ACTION_FIELD] [--cache-file CACHE_FILE] [--search SEARCH] [--limit LIMIT]

List Linkding bookmarks in a dmenu-compatible launcher and open an action menu for the selected URL.

options:
  -h, --help            show this help message and exit
  --config-file CONFIG_FILE
                        path to the config file. Default: "$XDG_CONFIG_HOME/linkmenu/linkmenu.conf"
  --server SERVER       Linkding base URL, e.g. https://linkding.example.com
  --token TOKEN         Linkding API token
  --launcher LAUNCHER   dmenu-compatible launcher command. Default: "walker --dmenu -p {prompt}"
  --inputautomation INPUTAUTOMATION
                        input automation command that reads the text to type from stdin. Default: "ydotool type --file -"
  --open-command OPEN_COMMAND
                        browser command; if it contains {url}, that placeholder is replaced, otherwise the URL is appended. Default: "xdg-open"
  --copy-command COPY_COMMAND
                        clipboard command that reads the URL from stdin. Will autodetect wl-copy, xclip, xsel or pbcopy
  --copy-action-field COPY_ACTION_FIELD
                        copy action field content. Default: "copy"
  --open-url-action-field OPEN_URL_ACTION_FIELD
                        url opener action field content. Default: "open"
  --autotype-action-field AUTOTYPE_ACTION_FIELD
                        autotype action field content. Default: "type"
  --cache-file CACHE_FILE
                        path to the JSON cache file. Default: "$XDG_CACHE_HOME/linkmenu/bookmarks.json"
  --search SEARCH       Optional Linkding search query
  --limit LIMIT         Optional maximum number of bookmarks to load; 0 means all. Default: 0
```

Examples:

```sh
linkmenu --search linux
linkmenu --limit 200
linkmenu --launcher 'rofi -dmenu'
linkmenu --open-command 'firefox {url}'
linkmenu --copy-command 'xclip -selection clipboard'
linkmenu --cache-file /tmp/linkmenu.json
linkmenu --config-file /tmp/linkmenu.conf
```

# Personal settings
I use a Linux-based machine for remote development using SSH and a macOS-based machine for local development. 

## Requirements
* VSCode >= 1.35
* tmux >= 2.9
* zsh >= 5.7

## Download
```
git clone https://github.com/k-lepa/settings ~/.settings
```

## Z shell
```
ln -s ~/.settings/zshrc ~/.zshrc
ln -s ~/.settings/zshenv ~/.zshenv
```
These settings are valid for local and remote machines. Additional environment variables should be in `~/.zshenv.local`.

### The environment variables
* TMUX_EXEC - use a different path to tmux's executable.
* TMUX_AUTOSTART - attach to a tmux's session automatically after login.
* TMUX_VSCODE_SOCK - use a separate tmux's socket for VSCode.

## tmux
```
ln -s ~/.settings/tmux.conf ~/.tmux.conf
```

## VSCode
### Local machine (macOS)
#### Extensions
In the integrated terminal apply [vscode-local-extensions.txt](vscode-local-extensions.txt):
```
pushd ~/.settings
cat vscode-local-extensions.txt | xargs -L 1 code --install-extension
popd
```

#### Settings (JSON)
```
ln -sf ~/.settings/vscode-local-settings.json ~/Library/Application\ Support/Code/User/settings.json
```

#### Keyboard shortcuts (JSON)
```
ln -sf ~/.settings/vscode-local-keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
```

### Remote machine (Linux)
#### Extensions
They should be installed manually. See [vscode-remote-extensions.txt](vscode-remote-extensions.txt).

#### Settings
```
{
        "terminal.integrated.shell.linux": "/usr/bin/zsh",
        "terminal.integrated.env.linux": {
                "TMUX_VSCODE_SOCK": "1"
        },
}
```

#### tmux's clipboard 
Add the executable script ~/.local/bin/pbcopy:
```
#!/bin/sh

tmpfile=$(mktemp /tmp/clip.XXXXXX)
cat - > $tmpfile
code --wait $tmpfile
rm -f $tmpfile
```
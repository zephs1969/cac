# cac
bash script to change Alacritty colours (cac.sh) immediately
﻿cac.sh:         change alacrittys colours ()
How it works:   The script substitutes the 'colour.toml' filename in
                ~/.config/alacritty/alacritty.toml import- statement.
                The import-statement to load the colour theme should be the first line e.g..
                import = [\"~/.config/alacritty/themes/themes/rainbow.toml\",]
                Alacritty changes the colour accordingly and is going to load the
                corresponding file after alacritty.toml was updated by cac.sh.
                The script downloads and install themes from git/alacritty-theme project.
                An update of themes do not touch existing custom themes.
Synopsis:       change alacrittys colour:= "cac.sh -h" shows options
Date:           12.08.2024
Version:        0.2a
Author:         zephyrus (Lars F.K.)

Usage:          cac.sh Idx.No.       := Select a colour theme by index number (Idx.No.).
                cac.sh "colour.toml"  := Select a colour theme by filename from
                                        "/home/username/.config/alacritty/themes/themes/".
                cac.sh -d, --default := Save & load a script coded theme as (username.toml)
                                        in /home/username/.config/alacritty/themes/themes/.
                cac.sh -h, --help    := Display and explain available options.
                cac.sh -i, --install := Create the themes folder, download alacritty themes
                                        and patch or create a configuration alacritty.toml.
                cac.sh -l, --list    := List available themes with corresponding index no.
                cac.sh -p, --print   := Print sample text in colour combinations to check
                                        the representation by current theme.
                cac.sh -s, --save    := Save the current colour theme as (username.toml) in
                                        "/home/username/.config/alacritty/themes/themes/".
                cac.sh -t, --theme   := Print name "name.toml" of the active theme.
                cac.sh -u, --update  := Download new colour themes from
                                        https://github.com/alacritty/alacritty-theme
                                        and keep your custom themes.

Install:        Copy the script into a folder included in $PATH and execute
                cac.sh -i

Changes:        On install an existing alacritty.toml configuration will be
                saved as alacritty.toml.bak in /home/username/.config/alacritty.
    new folder: mkdir -p /home/username/.config/alacritty/themes/
   load themes: git clone
                https://github.com/alacritty/alacritty-theme
                into /home/username/.config/alacritty/themes/
 AlacrittyCfg.: On install the script will ask if you wish to save a new default or patch
                your current config.(/home/username/.config/alacritty/alacritty.toml).

# [cac.sh][cac]
## bash script to [**c**hange **A**lacrittys **c**olour][cac] theme immediately

- change from a bright to a dark theme with a touch of a button
- explorer available Alacritty-themes on your screen
- test all colour-combinations of fore- and background colours on your screen with the current theme

use with:

...[Alacritty terminal emulator]: https://github.com/alacritty/alacritty

...[Alacritty themes]: https://github.com/alacritty/alacritty-theme


## Features

- Creates a basic Alacritty configuration
- Patches a existing Alacritty configuration to load themes
- Loads and updates available themes from github
- Switches to another theme
- Prints text examples to test the readability

## Requirements
Make sure that the following programs are installed:
 [alacritty][Ate], [find][find], [git][git], [rsync][rsync] and [sed][sed]

## How it works

The script substitutes the 'colour.toml' filename in the import-statement of the alacritty configuration file "home/username/.config/alacritty/alacritty.toml". 
Example of the import-statement to load a colour theme: 
```sh
import = [\"~/.config/alacritty/themes/themes/rainbow.toml\",]
```
Alacritty changes the colour of the terminal accordingly and is going to load the corresponding theme file immediately after alacritty.toml was updated by cac.sh. 
The script downloads and install themes from git/alacritty-theme project. An update of themes do not touch existing custom themes, if your files have a unique name.
## Installation
Change Alacritty Colour is a [public repository][cac]  on GitHub.
Download and copy the script into a folder included in $PATH and execute... 
```sh
cac.sh -i
```
...to install.
### Scripted Procedure: 
An existing alacritty.toml configuration will be saved as alacritty.toml.bak in /home/username/.config/alacritty. A new folder /home/username/.config/alacritty/themes/ will be created. Alacritty Themes are loaded from https://github.com/alacritty/alacritty-theme into /home/username/.config/alacritty/themes/ .
On install the script will ask if you wish to save a new default or patch your current configuration (/home/username/.config/alacritty/alacritty.toml).

## Usage
Select a colour theme by index number (Idx.No.):
```sh 
    cac.sh 1
```
Select a colour theme by filename from "/home/username/.config/alacritty/themes/themes/".:            
 ```sh
    cac.sh "rainbow.toml" 
```                                   
Save a script coded theme as (username.toml) in /home/username/.config/alacritty/themes/themes/ and then load it.
```sh
    cac.sh -d
  ```
   or
```sh
    cac.sh --default
```
Display and explain available options:
```sh
    cac.sh -h
```
   or
```sh
    cac.sh --help
```
Install procedure creates the themes folder, downloads the alacritty themes
and patches or creates a configuration alacritty.toml file.
```sh
     cac.sh -i
```
   or
```sh
     cac.sh --install
```
List available themes with corresponding index no.
```sh
    cac.sh -l
```
   or
 ```sh  
    cac.sh --list
```
 Print sample text in colour combinations to check the representation by the current theme.
 ```sh
    cac.sh -p
```
   or
```sh
    cac.sh --print
```                                   
Save the current colour theme as (username.toml) in "/home/username/.config/alacritty/themes/themes/".
```sh
    cac.sh -s
```
   or
 ```sh   
    cac.sh --save
```                                       
Print name "name.toml" of the active theme:
```sh
    cac.sh -t
```
   or
```sh   
    cac.sh --theme
```
Download new colour themes from https://github.com/alacritty/alacritty-theme and keep your custom themes:
```sh
    cac.sh -u
```
   or
```sh 
    cac.sh --update
```
## License

MIT - **Free Software...**

[//]: #
   [Ate]: <https://github.com/alacritty/alacritty>
   [find]: <https://man7.org/linux/man-pages/man1/find.1.html>
   [sed]: <https://man7.org/linux/man-pages/man1/sed.1.html>
   [rsync]: <https://man7.org/linux/man-pages/man1/rsync.1.html>
   [git]: <https://man7.org/linux/man-pages/man1/git.1.html>
   [cac]: <https://github.com/zephs1969/cac>
  

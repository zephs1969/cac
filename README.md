cac.sh (change Alacrittys colours)
 
Bash script to change Alacritty colours (cac.sh) immediately.

INSTALL: Download and copy the script into a folder included in $PATH and execute
cac.sh -i to install.
 
HOW IT WORKS: The script substitutes the 'colour.toml' filename in home/username/.config/alacritty/alacritty.toml" import- statement. The import-statement to load the colour theme should be the first line e.g.:

                import = [\"~/.config/alacritty/themes/themes/rainbow.toml\",]
                
Alacritty changes the colour accordingly and is going to load the corresponding file after alacritty.toml was updated by cac.sh. The script downloads and install themes from git/alacritty-theme project. An update of themes do not touch existing custom themes.

USAGE:          
Select a colour theme by index number (Idx.No.):
 
    cac.sh Idx.No.

Select a colour theme by filename from "/home/username/.config/alacritty/themes/themes/".:            
 
    cac.sh "colour.toml" 
                                        
Save a script coded theme as (username.toml) in /home/username/.config/alacritty/themes/themes/ and then load it.

    cac.sh -d
   or
  
    cac.sh --default

Display and explain available options:

    cac.sh -h
   or
   
    cac.sh --help

Install proc. create the themes folder, download alacritty themes
and patch or create a configuration alacritty.toml.

     cac.sh -i
   or
   
     cac.sh --install
INSTALL PROCEDURE: An existing alacritty.toml configuration will be saved as alacritty.toml.bak in /home/username/.config/alacritty. A new folder /home/username/.config/alacritty/themes/ will be created. Alacritty Themes are loaded from https://github.com/alacritty/alacritty-theme into /home/username/.config/alacritty/themes/ .
On install the script will ask if you wish to save a new default or patch your current config.(/home/username/.config/alacritty/alacritty.toml).


List available themes with corresponding index no.

    cac.sh -l
   or
   
    cac.sh --list

 Print sample text in colour combinations to check the representation by current theme.
 
    cac.sh -p
   or
   
    cac.sh --print
                                        
Save the current colour theme as (username.toml) in "/home/username/.config/alacritty/themes/themes/".

    cac.sh -s
   or
    
    cac.sh --save
                                        
Print name "name.toml" of the active theme:

    cac.sh -t
   or
   
    cac.sh --theme
                
Download new colour themes from https://github.com/alacritty/alacritty-theme and keep your custom themes:

    cac.sh -u
   or
   
    cac.sh --update


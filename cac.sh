    #!/bin/bash

    # Comments ###################################################################################
    #                                                                                            #
    ##############################################################################################
    #C cac.sh:       change alacrittys colours ()                                                #
    #How it works:   The script substitutes the 'colour.toml' filename in                        #
    #                ~/.config/alacritty/alacritty.toml import- statement.                       #
    #                The import-statement to load the colour theme should be the first line e.g..#
    #                import = [\"~/.config/alacritty/themes/themes/rainbow.toml\",]              #
    #                Alacritty changes the colour accordingly and is going to load the           #
    #                corresponding file after alacritty.toml was updated by cac.sh.              #
    #                The script downloads and install themes from git/alacritty-theme project.   #
    #                An update of themes do not touch existing custom themes.                    #
    #Synopsis:       change alacrittys colour:= "cac.sh -h" shows options                        #
    #Date:           12.08.2024                                                                  #
    #Version:        0.2a                                                                        #
    #Author:         zephyrus (Lars F.K.)                                                        #
    #                                                                                            #
    #Usage:          cac.sh Idx.No.       := Select a colour theme by index number (Idx.No.).    #
    #                cac.sh "colour.toml"  := Select a colour theme by filename from             #
    #                                        "/home/username/.config/alacritty/themes/themes/".  #
    #                cac.sh -d, --default := Save & load a script coded theme as (username.toml) #
    #                                        in /home/username/.config/alacritty/themes/themes/. #
    #                cac.sh -h, --help    := Display and explain available options.              #
    #                cac.sh -i, --install := Create the themes folder, download alacritty themes #
    #                                        and patch or create a configuration alacritty.toml. #
    #                cac.sh -l, --list    := List available themes with corresponding index no.  #
    #                cac.sh -p, --print   := Print sample text in colour combinations to check   #
    #                                        the representation by current theme.                #
    #                cac.sh -s, --save    := Save the current colour theme as (username.toml) in #
    #                                        "/home/username/.config/alacritty/themes/themes/".  #
    #                cac.sh -t, --theme   := Print name "name.toml" of the active theme.         #
    #                cac.sh -u, --update  := Download new colour themes from                     #
    #                                        https://github.com/alacritty/alacritty-theme        #
    #                                        and keep your custom themes.                        #
    #                                                                                            #
    #Install:        Copy the script into a folder included in $PATH and execute                 #
    #                cac.sh -i                                                                   #
    #                                                                                            #
    #Changes:        On install an existing alacritty.toml configuration will be                 #
    #                saved as alacritty.toml.bak in /home/username/.config/alacritty.            #
    #    new folder: mkdir -p /home/username/.config/alacritty/themes/                           #
    #   load themes: git clone                                                                   #
    #                https://github.com/alacritty/alacritty-theme                                #
    #                into /home/username/.config/alacritty/themes/                               #
    # AlacrittyCfg.: On install the script will ask if you wish to save a new default or patch   #
    #                your current config.(/home/username/.config/alacritty/alacritty.toml).      #
    #                                                                                            #
    ##############################################################################################

    # Initialization of Variables ################################################################################
    #                                                                                                            #
    export TOP_PID=$$                                       #Process ID of the current script 
    curUSER=$(id -un)                                       #current Username / Account
    intArgs=${#@}                                           #number of arguments passed to the script
    curCfgFileExtension=".toml"
    curCfgFile="${HOME}/.config/alacritty/alacritty.toml"   #The default user defined Alacritty configfile
    curThemesFolder="${curCfgFile%/*}/themes/themes/"       #The default themes folder 
    curGitFolder="${curCfgFile%/*}/themes/"
    curGitSource="https://github.com/alacritty/alacritty-theme" 
    zNewColorT=""                                           #Name of colour theme to switch to
    declare -a matAvailThemes=""                            #MATRIX for available colour themes
    myAskMode="w"                                           #fnc _ask w=waits for input without timeout
    bold=$(tput bold)                                       #to switch to bold font
    normal=$(tput sgr0)                                     #to switch to normal font 
    tout=5                                                  #fnc _asc timeout in seconds to wait for user input
    #                                                                                                            #
    #                                                                                                            #
    ##############################################################################################################
    version="0.1b"
    #C Name of the script file
    strSCR=cac.sh
    #                                                                                                            #
    ##############################################################################################################


    # Function Definitions #######################################################################################
    #                                                                                                            #
        _usage () {
            exitCode=${1:-0}
            printf "Usage %s: \n" "$strSCR" 
            printf "      %s %s\n" "$strSCR" "Idx.No.       := To select a colour theme by index number (Idx.No.)."
            printf "      %s %s\n" "$strSCR" "\"colour.toml\"  := To select a colour theme by filename from \"$curThemesFolder\"."
            printf "      %s %s\n" "$strSCR" "-d, --default := To save & load a script coded colour theme as (${curUSER}.toml) in \"$curThemesFolder\"."
            printf "      %s %s\n" "$strSCR" "-h, --help    := To display and explain available options." 
            printf "      %s %s\n" "$strSCR" "-i, --install := To create the themes folder, download alacritty themes and patch or create a configuration (alacritty.toml)."
            printf "      %s %s\n" "$strSCR" "-l, --list    := To list all available themes with coresponding index numbers."
            printf "      %s %s\n" "$strSCR" "-p, --print   := Print sample text in some colour combinations to check the representation by current theme."
            printf "      %s %s\n" "$strSCR" "-s, --save    := To save the current colour theme as (${curUSER}.toml) in \"$curThemesFolder\"."
            printf "      %s %s\n" "$strSCR" "-t, --theme   := To print the filename \"name.toml\" of the active colour theme."
            printf "      %s %s\n" "$strSCR" "-u, --update  := To download new colour themes from $curGitSource and keep custom themes."
            printf "\n"
            printf "Install %s:\n" "$strSCR" 
            printf "      %s\n" "Copy the script into a folder included in \$PATH"
            printf "      %s %s %s\n" "and execute:" "$strSCR" "-i"
            printf "      Changes:\n"      
            printf "      %s\n" "An existing alacritty.toml configuration will be"
            printf "      %s %s.\n" "saved as alacritty.toml.bak in" "${curCfgFile%/*}"
            printf "      %s %s\n" "new folder: mkdir -p" "$curGitFolder"
            printf "      %s %s\n" "load themes: git clone https://github.com/alacritty/alacritty-theme" "$curGitFolder"
            printf "      %s %s.\n" "Alacritty Config.: The script will ask if you wish to save a new or patch your current config." "${curCfgFile}"
           _zExit "${exitCode}"
        }
       
        _zExit () {
            exitCode=${1:-0}
            shopt -u extglob
            #printf "%s terminates.\n" $strSCR
            exit "$exitCode"
            kill -s TERM "$TOP_PID"
        }
        _echoerr () {
            printf "%s\n" "${strSCR} Error: $*" >&2
        }
        
        _isDirEmpty () {
        #printf "_isDirEmpty called with:%s.\n" "$1"
        if [[ -z $1 ]]; then
            echo "1"
        else
            if [[ $(ls -A "$1" ) ]]; then
                #printf "Exit with 1 - is not empty"
                echo 1
            else
                #printf "Exit with 0 - is empty"
                echo 0
            fi
        fi
        }
        
        _ask () {
            strQuest=${1:-'no question?'}
            while true; do
                    case "$myAskMode" in
                            "w")
                                read -r -p "$strQuest (${bold}Y${normal}/n)?" answer
                                err=$?
                                ;;
                            "y")
                                read -r -t $tout -p "$strQuest timeout=$tout s (${bold}Y${normal}/n)?" answer
                                err=$?
                                ;;
                            "n")
                                read -r -t $tout -p "$strQuest timeout=$tout s (y/${bold}N${normal})?" answer
                                err=$?
                                ;;
                    esac

                    if [[ "$err" != "0" || "$answer" == ""  ]]; then
                        case "$myAskMode" in
                            "w")
                                answer="y"
                                ;;
                            "y")
                                answer="y"
                                ;;
                            "n")
                                answer="n"
                                ;;
                        esac
                    fi

                    case "$answer" in
                        [yY]*)
                                echo "0";
                                break;
                                ;;
                        [nN]*)
                                echo "1";
                                break;
                                ;;
                    esac
                    answer=''
                done
        }
        
        _checkCFG () {
            if ! which alacritty find git rsync sed > \dev\null; then
                _echoerr "Dependencies - to use $strSCR \"alacritty\", \"find\", \"git\", \"rsync\" and \"sed\" have to be installed."
                _zExit "1"
            fi
            
            if ! [[ -f "${curCfgFile}" ]]; then
                _echoerr "File not found - ${curCfgFile}"
                if [[ $(_ask "Write a new default configuration as  $curCfgFile?") == "0" ]]; then
                    _writeDefaultCFGFile
                fi
                _zExit "1"
            fi

            if ! [[ -d "${curThemesFolder}" ]]; then
                _echoerr "Folder not found - ${curThemesFolder}"
                _echoerr "Execute $strSCR -i to create the themes folder and download the themes."
                _zExit "1"
            fi

            zTest=$(sed -n '/^import/{p;q;}' "$curCfgFile"); 
            if [[ -z $zTest ]] ; then
                _echoerr "No import statement of a colour theme found in $curCfgFile"
                if [[ $(_ask "Insert import statement into $curCfgFile?") == "0" ]]; then
                    _patchCFG
                fi
                _zExit "1"
            fi
           
           #Load the available themes and proof that there are some...            
            _availThemes
        }
        
        _patchCFG () {
            if ! sed -i '1 i\import = [\"~/.config/alacritty/themes/themes/rainbow.toml\",]' "${curCfgFile}"; then
                _echoerr "Err.No.: $? while trying to change ${curCfgFile}"
                _zExit "1"
            fi
        }
        
        _curColorTheme () {
            zTest=$(sed -n '/^import/{p;q;}' "$curCfgFile"); 
            if [[ -z $zTest ]]; then 
                _echoerr "Err. No. $? while trying to read first import statement with coresponding colour.toml in $curCfgFile"
                _zExit "1"
            fi
            zTest=${zTest##*/} ;
            zTest=${zTest%\"*} ;
            echo "$zTest"
        }
        
        _bakConfig () {
            #printf "fnc _bakConfig running with param. %s\n" "$1"
            if cp "$1"{,.bak}; then
                #printf "%s --> s%.bak\n" "$1" "$1";
                echo "0"
            else
                _echoerr "$? -  No $1.bak backup created!";
                echo "1"
            fi
        }

        _restConfig () {
            if cp "${1}.bak" "${1}"; then
                echo "0"
            else 
                echo "1"
            fi 
        }

        _selThemeByNo () {
            if [[ -z $1 ]]; then
                _echoerr "fnc _selThemeByNo called without selector (Idx.No.)"
            fi
            myIndex=$(($1*2+1))
            myBorder=$((${#matAvailThemes[@]}/2))
            if [[ "$1" -ge "0" ]] && [[ "$1" -le "$myBorder" ]]; then
                    zCurColorT=$(_curColorTheme)
                    zNewColorT="${matAvailThemes[$myIndex]}"
                    #printf "old: %s new: %s...\n" $zCurColorT $zNewColorT
                    sed -i -e "0,/${zCurColorT}/s//${zNewColorT}/" "$curCfgFile"
                else 
                    _echoerr "fnc _selThemeByNo called with selector out of range (Idx.No.)"
                    _zExit "1"
            fi 
        }
        
        _selThemeByName () {
             if [[ -f "${curThemesFolder}$1" ]]; then
                    zCurColorT=$(_curColorTheme)
                    zNewColorT="${1}"
                    sed -i -e "0,/${zCurColorT}/s//${zNewColorT}/" "$curCfgFile"
                else
                    _echoerr "\"${1}\" seems not to be a valid toml-file in ${curThemesFolder}."
                    _zExit "1"
                fi       
            }
            
        _availThemes () {
            read -r -a matAvailThemes <<< "$(find $curThemesFolder  -type f -iname *.toml -exec basename  '{}' ';' | nl -v 0 | tr -d '\n' | tr '\t' ' ')"
            if [[ ${#matAvailThemes[@]} -le 0 ]]; then
                _echoerr "There are no themes in ${curThemesFolder}."
                _zExit "1"
            fi
        }
        
        _printColors () {
            printf "|039| \033[39mDefault \033[m  |049| \033[49mDefault \033[m  |037| \033[37mLight gray \033[m     |047| \033[47mLight gray \033[m\n"
            printf "|030| \033[30mBlack \033[m    |040| \033[40mBlack \033[m    |090| \033[90mDark gray \033[m      |100| \033[100mDark gray \033[m\n"
            printf "|031| \033[31mRed \033[m      |041| \033[41mRed \033[m      |091| \033[91mLight red \033[m      |101| \033[101mLight red \033[m\n"
            printf "|032| \033[32mGreen \033[m    |042| \033[42mGreen \033[m    |092| \033[92mLight green \033[m    |102| \033[102mLight green \033[m\n"
            printf "|033| \033[33mYellow \033[m   |043| \033[43mYellow \033[m   |093| \033[93mLight yellow \033[m   |103| \033[103mLight yellow \033[m\n"
            printf "|034| \033[34mBlue \033[m     |044| \033[44mBlue \033[m     |094| \033[94mLight blue \033[m     |104| \033[104mLight blue \033[m\n"
            printf "|035| \033[35mMagenta \033[m  |045| \033[45mMagenta \033[m  |095| \033[95mLight magenta \033[m  |105| \033[105mLight magenta \033[m\n"
            printf "|036| \033[36mCyan \033[m     |046| \033[46mCyan \033[m     |096| \033[96mLight cyan \033[m     |106| \033[106mLight cyan \033[m\n"
       }
    
       _printAvailThemes () {
            echo -e "\n"
            #echo "Items:${#matAvailThemes[@]}.."
            for ((i0=0; i0<${#matAvailThemes[@]}; i0=i0+2))
            do
                if [[ $i0+1 -gt ${#matAvailThemes[@]} ]]; then
                    break
                fi
                printf " %s %s \n" "${matAvailThemes[$i0]}" "${matAvailThemes[$i0+1]}" 
            done 
        }
        
        _updateThemes () {
             if [[ $(_ask "Do you want to merge your existing themes-folder with a fresh copy from git?") == "0" ]]; then
                    if mv ${curGitFolder%/*}{,_bak}; then
                        printf "A backup was created as %s_bak/themes/.\n" "${curGitFolder%/*}"
                    else 
                        _echoerr "Err.No.: $? - failed to create backup of themes-folder."
                        _zExit "1"
                    fi
                    mkdir -p "$curGitFolder"
                    git clone "${curGitSource}" "${curGitFolder}"
                    #printf "CurBackGitFolder: %s->%s.\n"  "${curGitFolder%/*}_bak/themes/"  "${curThemesFolder}"
                    if rsync -rauv "${curGitFolder%/*}_bak/themes/" "${curThemesFolder}" > /dev/null; then 
                        printf "Themes-folders are syncronized. Removing backup...\n"
                        rm -rf "${curGitFolder%/*}_bak"
                    else 
                        _echoerr "Err. No.: $? while syncronizing themes-folders. Use backup of themes: ${curGitFolder%/*}_bak"
                        zExit "1"
                    fi
             fi 
        }
        
        _fncCreateCfg () {
            if [[ -f $curCfgFile ]]; then
                printf "cfg %s exists\n" "$curCfgFile"
                if ! [[ $(_bakConfig "$curCfgFile") == "0" ]]; then
                    printf "No backup of %s created!\n" "$curCfgFile"
                    if [[ $(_ask "Exit install?") == "0" ]]; then
                        _zExit "0"
                    fi
                else
                    printf "Backup of %s created as %s.bak\n" "$curCfgFile" "$curCfgFile"
                fi
            fi 
            
            #printf "Test if themes-folder is empty starts...\n"
            #_isDirEmpty "${curThemesFolder}"
            if [[ $(_isDirEmpty "${curThemesFolder}") == "1" ]]; then
                _updateThemes
            fi
            
            if ! [[ -d "$curGitFolder" ]]; then 
                mkdir -p "$curGitFolder"
            fi
            
            if [[ $(_isDirEmpty "${curThemesFolder}") == "0" ]]; then
                git clone "${curGitSource}" "${curGitFolder}"
            fi
            
            zTest=$(sed -n '/^import/{p;q;}' "$curCfgFile") 
            if [[ -f "${curCfgFile}" ]] && [[ -z "${zTest}" ]] && [[ $(_ask "Keep your alacritty.toml configuration and patch it to work with ${strSCR}?") == "0" ]]; then
                _patchCFG
                _zExit "0"
            fi 
            
            if ! [[ $(_ask "Write a new default alacritty.toml configuration?") == "0" ]]; then
               _zExit "0"
            else            
                if [[ -f "$curCfgFile" ]]; then
                    rm -f "$curCfgFile"
                fi

                if ! _writeDefaultCFGFile; then
                    _echerr "Err. No.: $? - while writing the default configuration as $curCfgFile"
                    if [[ $(_restConfig "$curCfgFile") == "0" ]]; then
                       printf "Backup of %s restored." "$curCfgFile"
                    fi 
                fi
            fi
        }
        
        _writeDefaultCFGFile () {
        cat << 'EOF' > "$curCfgFile"
#Don't change the first line starting with 'import...' if you are useing the script 'cac.sh'
import = ["~/.config/alacritty/themes/themes/rainbow.toml",]

[colours]

#[colours.bright]
#black = "#6c6823"
#blue = "#477ca1"
#cyan = "#75a738"
#green = "#18974e"
#magenta = "#8868b3"
#red = "#c35359"
#white = "#faf0a5"
#yellow = "#a88339"

#[colours.cursor]
#cursor = "#948e48"
#text = "#201602"

#[colours.normal]
#black = "#201602"
#blue = "#477ca1"
#cyan = "#75a738"
#green = "#18974e"
#magenta = "#8868b3"
#red = "#c35359"
#white = "#948e48"
#yellow = "#a88339"

#[colours.primary]
#background = "#201602"
#foreground = "#948e48"

[env]
TERM = "xterm-256colour"

#[font]
#size = 15
#
#[font.bold]
#family = "IBM Plex Mono"
#style = "Heavy"
#
#[font.bold_italic]
#family = "IBM Plex Mono"
#style = "Heavy Italic"
#
#[font.italic]
#family = "IBM Plex Mono"
#style = "Medium Italic"
#
#[font.normal]
#family = "IBM Plex Mono"
#style = "Medium"
##style = "Regular"
#
#[font.offset]
#x = 0
#y = 0

[[keyboard.bindings]]
action = "SpawnNewInstance"
key = "Return"
mods = "Super|Control"

[scrolling]
multiplier = 6

[selection]
save_to_clipboard = true

[window]
decorations_theme_variant = "None"
dynamic_padding = true
startup_mode = "Maximized"
opacity = 1

[window.dimensions]
columns = 120
lines = 43

[window.padding]
x = 5
y = 5

[window.position]
x = 5
y = 5
EOF
}

    _fncCreateUserDefinedCS () {
        newUserTheme="${curThemesFolder}${1}"
        curUserTheme="${curThemesFolder}$(_curColorTheme)"
        #printf "newUserTheme:%s.\n" "${newUserTheme}"
        if [[ -f "$newUserTheme" ]]; then
            if [[ $(_bakConfig "$newUserTheme") ]]; then
                #printf "copy %s %s\n" "${curUserTheme}" "${newUserTheme}" 
                cp -f "${curUserTheme}" "${newUserTheme}"   
                #printf "copied... and exiting."
               _zExit "0"
            fi
        fi
    }

    _fncCreateDefaultCS () {
        newUserTheme="${curThemesFolder}${1}"
        cat << 'EOF' > "$newUserTheme" 
[colours]
[colours.primary]
background = '#192835'
foreground = '#AADA4F'

[colours.normal]
black   = '#5B4375'
red     = '#426bb6'
green   = '#2286b5'
yellow  = '#5ab782'
blue    = '#93ca5b'
magenta = '#c6c842'
cyan    = '#8a5135'
white   = '#c54646'

[colours.bright]
black   = '#5B4375'
red     = '#426bb6'
green   = '#2286b5'
yellow  = '#5ab782'
blue    = '#93ca5b'
magenta = '#c6c842'
cyan    = '#8a5135'
white   = '#c54646'

[colours.cursor]
cursor = "#948e48"
text = "#201602"
EOF
    _selThemeByName "${1}"
    }

    #                                                                                                            #
    ##############################################################################################################


    # Runtime Configuration and Options (parse options, read configuration file etc.) ############################
    #                                                                                                            #
    
    shopt -s extglob
    trap "exit 1" TERM
    
    #                                                                                                            #
    ##############################################################################################################


    # Sanity Check (are all values reasonable?) ##################################################################
    #                                                                                                            #
    
    if ! [[ "$intArgs" = "1" ]]; then
       #echo -e "...not one arg. /n"
        _usage "1"
    fi
    
    #                                                                                                            #
    ##############################################################################################################
    

    # Process Information (valculate, slice and dice lines, I/O...) ##############################################
    #                
    #
    case "$1" in
        -h|--help)
            ;;
        *)
            _checkCFG ;;
    esac

    case "$1" in
        -h|--help)
            _usage "0" ;;
        -i|--install)  
            _fncCreateCfg ;;
        -l|--list)
            _printAvailThemes ;;
        -t|--theme)
            _curColorTheme ;;
        -u|--update)
            _updateThemes ;;
        -p|--print)
            _printColors ;;
        -d|--default)
            _fncCreateDefaultCS "${curUSER}${curCfgFileExtension}";;
        -s|--save)
            _fncCreateUserDefinedCS "${curUSER}${curCfgFileExtension}";;
       +([[:digit:]]) )
            #echo -e "digit true...\n"
            _selThemeByNo "${1}" ;;
        *)
            _selThemeByName "${1}" ;;
    esac
    shopt -u extglob
    exit 0;
    
    #                                                                                                            #
    ##############################################################################################################

# Set default editor
set -gx EDITOR nvim
set -gx VISUAL nvim

# Bind ctrl+O to ranger-cd
bind \co ranger-cd

# Change cursor shape per vi mode
set fish_cursor_default     block      blink
set fish_cursor_insert      line       blink
set fish_cursor_replace_one underscore blink
set fish_cursor_visual      block

if status is-interactive
    set -l onedark_options '-b'

    if set -q VIM
        # Using from vim/neovim.
        set onedark_options "-256"
    else if string match -iq "eterm*" $TERM
        # Using from emacs.
        function fish_title; true; end
        set onedark_options "-256"
    end

    set_onedark $onedark_options
end

# Override fish greeting from omf theme
function fish_greeting
end

# Override fish mode prompt from omf theme
function fish_mode_prompt
end

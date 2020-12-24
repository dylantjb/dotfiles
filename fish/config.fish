# Set default editor
set -gx EDITOR nvim

# Use vim keys
fish_vi_key_bindings

# Overwrite default greeting
set fish_greeting

# Find number of terminals open
set TERM_INSTANCES 0
for pid in (string split ' ' (pidof -x alacritty))
    set TERM_INSTANCES (math $TERM_INSTANCES + 1)
end

# Display neofetch if one terminal open
if [ $TERM_INSTANCES -eq 1 ]
    neofetch | lolcat
end


# #---Keats downloader alias---# #
# Alias for keats downloader
function keats --wraps='./Projects/Keats Downloader/run' --wraps=./Projects/Keats\\\ Downloader\run --description 'alias keats ./Projects/Keats Downloader/run'
    ./Projects/Keats\ Downloader/run $argv;
end

# #---Git branch function---# #
# Display git branch in prompt when in directory
function _git_branch_name
  echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

# #---Dirty git function---# #
# Display dirty status in prompt
function _is_git_dirty
  echo (command git status -s --ignore-submodules=dirty ^/dev/null)
end

# #---Fish prompt function---# #
# Prompt colours + git and virtual environment status
function fish_prompt
  set -l last_status $status
  set -l purple (set_color -o B294BB)
  set -l white (set_color -o FFFFFF)
  set -l primary (set_color -o 282D3C)
  set -l cyan (set_color -o 8BE9FD)
  set -l yellow (set_color -o E6DB74)
  set -l red (set_color -o CC6666)
  set -l blue (set_color -o 66D9EF)
  set -l green (set_color -o 00C853)
  set -l orange (set_color -o FFB74D)
  set -l normal (set_color normal)

  if test $last_status = 0
      set status_indicator "$white➜ "
  else
      set status_indicator "$red✗ "
  end

  if set -q VIRTUAL_ENV
    echo -n -s (set_color -b blue white) "(" (basename "$VIRTUAL_ENV") ")" (set_color normal) " "
  end

  set -l cwd $blue(prompt_pwd)

  if [ (_git_branch_name) ]

    if test (_git_branch_name) = 'master'
      set -l git_branch (_git_branch_name)
      set git_info "$white ($purple$git_branch$white)"
    else
      set -l git_branch (_git_branch_name)
      set git_info "$normal ($blue$git_branch$normal)"
    end

    if [ (_is_git_dirty) ]
      set -l dirty "$yellow ✗"
      set git_info "$git_info$dirty"
    end
  end

  # Notify if a command took more than 5 minutes
  if [ "$CMD_DURATION" -gt 300000 ]
    echo The last command took (math "$CMD_DURATION/1000") seconds.
  end

  echo -n -s $cwd $git_info ' ' $status_indicator $normal
end

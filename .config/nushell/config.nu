# config.nu
#
# Installed by:
# version = "0.110.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings, 
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R

$env.config.buffer_editor = "hx"
$env.config.show_banner = false

$env.PYTHONSTARTUP = $"($env.HOME)/.pythonrc.py"
$env.RIPGREP_CONFIG_PATH = $"($env.HOME)/.config/.ripgreprc"
$env.GPG_TTY = (tty)
$env.PATH = $env.PATH? | prepend [
  "/Users/trag1c/.local/bin"
  "/Users/trag1c/dev/bin"
  "/Users/trag1c/.cargo/bin"
  "/opt/homebrew/bin"
  "/usr/local/bin"
]
$env.HELIX_RUNTIME = "~/dev/download/helix/runtime"
$env.EDITOR = "hx"

def hcb-api [path: string] {
  http get $"https://hcb.hackclub.com/api/v3($path)"
}

def worktree [dirname: string, branch_name?: string] {
  let branch_name = $branch_name | default $dirname
  git branch $branch_name
  git worktree add $"../wt-($dirname)" $branch_name
}

alias cp = cp -vi
alias mv = mv -vi
alias rd = rmdir
alias rm = rm -v

alias lg = lazygit
alias neofetch = fastfetch
alias python = uv run python
alias rust = evcxr
alias uvhx = uv run hx
alias zq = zoxide query
alias oc = opencode

alias ga = git add
alias gb = git branch
alias gbd = git branch --delete
alias gc = git commit -S --verbose
alias gcb = git checkout -b
alias gco = git checkout
alias gcl = git clone
alias gd = git diff
alias gds = git diff --staged
alias gl = git pull
alias glog = git log --all --graph --pretty=format:'%C(magenta)%h %C(white) %an  %ar%C(auto)  %D%n%s%n'
alias gp = git push
alias gpfwl = git push --force-with-lease
alias grh = git reset --hard
alias gst = git status --short

alias j = jj
alias jjj = jj
alias jr = jj rebase -d main

def jj-sync [] {
  jj git fetch
  jj git rebase -d main
}

source .atuin.nu
source .zoxide.nu

def get_index_change_count [gs] {
  let index_new = ($gs | get idx_added_staged)
  let index_modified = ($gs | get idx_modified_staged)
  let index_deleted = ($gs | get idx_deleted_staged)
  let index_renamed = ($gs | get idx_renamed)
  let index_typechanged = ($gs | get idx_type_changed)

  $index_new + $index_modified + $index_deleted + $index_renamed + $index_typechanged
}

def get_working_tree_count [gs] {
  let wt_modified = ($gs | get wt_modified)
  let wt_deleted = ($gs | get wt_deleted)
  let wt_typechanged = ($gs | get wt_type_changed)
  let wt_renamed = ($gs | get wt_renamed)

  $wt_modified + $wt_deleted + $wt_typechanged + $wt_renamed
}

def get_conflicted_count [gs] {
  ($gs | get conflicts)
}

def get_untracked_count [gs] {
  ($gs | get wt_untracked)
}

def get_branch_name [gs] {
  let br = ($gs | get branch)
  if $br == "no_branch" {
    ""
  } else {
    $br
  }
}

def get_ahead_count [gs] {
  ($gs | get ahead)
}

def get_behind_count [gs] {
  ($gs | get behind)
}

def get_icons_list [] {
  {
    AHEAD_ICON: (char branch_ahead) # "↑" 2191
    BEHIND_ICON: (char branch_behind) # "↓" 2193
    NO_CHANGE_ICON: (char branch_identical) # ≣ 2263
    HAS_CHANGE_ICON: "*"
    INDEX_CHANGE_ICON: "♦"
    WT_CHANGE_ICON: "✚"
    CONFLICTED_CHANGE_ICON: "✖"
    UNTRACKED_CHANGE_ICON: (char branch_untracked) # ≢ 2262
    REBASE_ICON: "" # e728
  }
}

def get_icon_by_name [name] {
  get_icons_list | get $name
}

def get_repo_status [gs os] {
  let display_path = (home-abbrev | abbreviate (term size).columns)
  let branch_name = (get_branch_name $gs)
  let ahead_cnt = (get_ahead_count $gs)
  let behind_cnt = (get_behind_count $gs)
  let index_change_cnt = (get_index_change_count $gs)
  let wt_change_cnt = (get_working_tree_count $gs)
  let conflicted_cnt = (get_conflicted_count $gs)
  let untracked_cnt = (get_untracked_count $gs)
  let has_no_changes = (
    ($index_change_cnt <= 0) and
    ($wt_change_cnt <= 0) and
    ($conflicted_cnt <= 0) and
    ($untracked_cnt <= 0)
  )

  let AHEAD_ICON = (get_icon_by_name AHEAD_ICON)
  let BEHIND_ICON = (get_icon_by_name BEHIND_ICON)
  let INDEX_CHANGE_ICON = (get_icon_by_name INDEX_CHANGE_ICON)
  let CONFLICTED_CHANGE_ICON = (get_icon_by_name CONFLICTED_CHANGE_ICON)
  let WT_CHANGE_ICON = (get_icon_by_name WT_CHANGE_ICON)
  let UNTRACKED_CHANGE_ICON = (get_icon_by_name UNTRACKED_CHANGE_ICON)
  let NO_CHANGE_ICON = (get_icon_by_name NO_CHANGE_ICON)
  let HAS_CHANGE_ICON = (get_icon_by_name HAS_CHANGE_ICON)

  $"( if ($ahead_cnt > 0) {$'($AHEAD_ICON)($ahead_cnt)'}
  )( if ($behind_cnt > 0) {$'($BEHIND_ICON)($behind_cnt)'}
  )( if ($index_change_cnt > 0) {$'($INDEX_CHANGE_ICON)($index_change_cnt)'}
  )( if ($conflicted_cnt > 0) {$'($CONFLICTED_CHANGE_ICON)($conflicted_cnt)'}
  )( if ($wt_change_cnt > 0) {$'($WT_CHANGE_ICON)($wt_change_cnt)'}
  )( if ($untracked_cnt > 0) {$'($UNTRACKED_CHANGE_ICON)($untracked_cnt)'}
  )( if $has_no_changes {$'($NO_CHANGE_ICON)'} else {$'($HAS_CHANGE_ICON)'}
  )"
}

def home-abbrev [] {
  if ($env.PWD | str starts-with $nu.home-dir) {
    $env.PWD | str replace $nu.home-dir '~'
  } else {
    $env.PWD
  }
}

def padding [] {
  each {
    if ($in | str length) == 0 {
      $in
    } else {
      $"($in) "
    }
  }
}

def abbreviate [threshold: int] {
  each {
    if ($in | str length) <= ($threshold / 3) {
      return $in
    }
    let words = $in | split row "/"
    let first_chars = $words | drop | str substring 0..0
    let cwd = $words | last
    $first_chars | append $cwd | str join "/"
  }
}

def prepare-path [] {
  home-abbrev | abbreviate (term size).columns | padding
}

$env.PROMPT_COMMAND = { prepare-path }
$env.PROMPT_INDICATOR = "λ "
$env.TRANSIENT_PROMPT_COMMAND = {
  let time = date now | format date "%H:%M:%S"
  let path = home-abbrev | path basename | padding
  let sep = $"(ansi light_cyan)|(ansi light_green)"
  $"($time) ($sep) ($path)"
}
$env.PROMPT_COMMAND_RIGHT = {
  let gs = (gstat)
  if ($gs | get repo_name) == "no_repository" {
    return ""
  }
  let branch = $gs | get branch
  $" ($branch) (get_repo_status $gs macos)"
}


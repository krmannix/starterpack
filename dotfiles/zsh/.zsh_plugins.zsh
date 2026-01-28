fpath+=( "$HOME/Library/Caches/antidote/mattmc3/ez-compinit" )
source "$HOME/Library/Caches/antidote/mattmc3/ez-compinit/ez-compinit.plugin.zsh"
fpath+=( "$HOME/Library/Caches/antidote/zsh-users/zsh-completions/src" )
fpath+=( "$HOME/Library/Caches/antidote/aloxaf/fzf-tab" )
source "$HOME/Library/Caches/antidote/aloxaf/fzf-tab/fzf-tab.plugin.zsh"
fpath+=( "$HOME/Library/Caches/antidote/belak/zsh-utils/completion/functions" )
builtin autoload -Uz $fpath[-1]/*(N.:t)
compstyle_zshzoo_setup
fpath+=( "$HOME/Library/Caches/antidote/belak/zsh-utils/editor" )
source "$HOME/Library/Caches/antidote/belak/zsh-utils/editor/editor.plugin.zsh"
fpath+=( "$HOME/Library/Caches/antidote/ohmyzsh/ohmyzsh/plugins/git" )
source "$HOME/Library/Caches/antidote/ohmyzsh/ohmyzsh/plugins/git/git.plugin.zsh"
fpath+=( "$HOME/Library/Caches/antidote/belak/zsh-utils/history" )
source "$HOME/Library/Caches/antidote/belak/zsh-utils/history/history.plugin.zsh"
fpath+=( "$HOME/Library/Caches/antidote/romkatv/powerlevel10k" )
source "$HOME/Library/Caches/antidote/romkatv/powerlevel10k/powerlevel10k.zsh-theme"
source "$HOME/Library/Caches/antidote/romkatv/powerlevel10k/powerlevel9k.zsh-theme"
if is-macos; then
  fpath+=( "$HOME/Library/Caches/antidote/zshzoo/macos" )
  source "$HOME/Library/Caches/antidote/zshzoo/macos/macos.plugin.zsh"
fi
fpath+=( "$HOME/Library/Caches/antidote/belak/zsh-utils/utility" )
source "$HOME/Library/Caches/antidote/belak/zsh-utils/utility/utility.plugin.zsh"
export PATH="$HOME/Library/Caches/antidote/romkatv/zsh-bench:$PATH"
fpath+=( "$HOME/Library/Caches/antidote/mfaerevaag/wd" )
source "$HOME/Library/Caches/antidote/mfaerevaag/wd/wd.plugin.zsh"
fpath+=( "$HOME/Library/Caches/antidote/zdharma-continuum/fast-syntax-highlighting" )
source "$HOME/Library/Caches/antidote/zdharma-continuum/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
fpath+=( "$HOME/Library/Caches/antidote/zsh-users/zsh-autosuggestions" )
source "$HOME/Library/Caches/antidote/zsh-users/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
fpath+=( "$HOME/Library/Caches/antidote/zsh-users/zsh-history-substring-search" )
source "$HOME/Library/Caches/antidote/zsh-users/zsh-history-substring-search/zsh-history-substring-search.plugin.zsh"

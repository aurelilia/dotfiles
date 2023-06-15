#!/bin/sh

# Install files
function dit {
  	git --git-dir=$HOME/.config/dotfiles/ --work-tree=$HOME $@
}
git clone --bare https://git.elia.garden/ellie/dotfiles.git $HOME/.config/dotfiles
dit checkout
dit config status.showUntrackedFiles no

ln -s ~/dotfiles/.aliases ~/.aliases
ln -s ~/dotfiles/.zshrc ~/.zshrc
# ln -s ~/dotfiles/.p10k.zsh ~/.p10k.zsh
ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -s ~/dotfiles/.vimrc ~/.vimrc

ln -s ~/dotfiles/.condarc ~/.condarc
# cp ./.gitconfig ~/.gitconfig

mkdir ~/.pip
ln ~/dotfiles/pip.conf ~/.pip/pip.conf

source ~/.zshrc
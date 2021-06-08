# edurso's dotfiles

## First Time Set-Up

```
mkdir $HOME/dotfiles 
git init --bare $HOME/dotfiles
echo "alias dotfile='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'" >> ~/.bashrc
dotfile config --local status.showUntrackedFiles no
dotfile pull
```

## Adding New dotfiles

```
dotfile add /path/of/file
dotfile commit -m "added new file"
dotfile push
```

Note that in `.zshrc`, the `dotfile` alias is also aliased as `df`.


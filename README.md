# dotfiles

```
git clone https://github.com/spraints/dotfiles spraints/dotfiles
cd spraints/dotfiles

# this is not working yet:
cp ~/someplace-safe/template-vars.sh template-vars.sh
script/compile-templates

script/install-dotfiles
script/install-config --all
```

## In codespaces

I may expand on this, but for now just copy/paste this:

```
git clone https://github.com/spraints/dotfiles ~/.dotfiles
(cd ~/.dotfiles && script/install-dotfiles)
```

... and then copy `~/.gitconfig.orig` over the similar bits in `~/.gitconfig`.

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

Enable [automatic installation in your settings](https://github.com/settings/codespaces), or do this manually:

```
git clone https://github.com/spraints/dotfiles ~/.dotfiles
(cd ~/.dotfiles && script/install-codespaces)
```

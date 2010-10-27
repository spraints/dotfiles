Usage:

Move dotfile from your home directory to here and link from home to here:

    thor dotfiles:grab ~/.somefile [--test]

If you create dotfiles here, or just moved to a new machine:

    thor dotfiles:install [--force] [--test]

If you want to have an ERB template for your dotfile, create somefile.erb.
Then:

    thor dotfiles:erb [--test]
    thor dotfiles:diff

If you have a link to something you don't need:

    thor dotfiles:uninstall thing_i_should_not_have_had_here

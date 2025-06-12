watch-git-systems-merge-queues() {
  watch -n 60 --color 'for r in babeld codeload spokesd gitrpcd; do echo ........; merge-queue github/$r; done'
}
# ok: zsh

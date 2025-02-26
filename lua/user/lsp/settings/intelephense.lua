return {
  settings = {
    intelephense = {
      environment = {
        documentRoot = '/home/user/git/drupal',
        includePaths = { 'core/', 'core/includes', '../vendor/' },
      },
      files = {
        associations = { '*.php', '*.phtml', '*.module', '*.inc' },
      },
    },
  },
}

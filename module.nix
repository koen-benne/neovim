inputs:
{ config, wlib, lib, pkgs, ... }:
{
  imports = [ wlib.wrapperModules.neovim ];

  # Point at our lua config directory
  config.settings.config_directory = ./.;

  # Shell aliases
  config.settings.aliases = [ "nv" ];

  # Allow querying which top-level specs are enabled from lua:
  # nixInfo(false, "settings", "cats", "general")
  options.settings.cats = lib.mkOption {
    readOnly = true;
    type = lib.types.attrsOf lib.types.bool;
    default = builtins.mapAttrs (_: v: v.enable) config.specs;
  };

  # Colorscheme: set here, read in lua via nixInfo("kanagawa", "settings", "colorscheme")
  options.settings.colorscheme = lib.mkOption {
    type = lib.types.str;
    default = "kanagawa";
  };

  # Extra info passed to lua via nixInfo(nil, "info", ...)
  config.info = {
    nixdExtras = {
      nixpkgs = toString inputs.nixpkgs;
      # Uncomment and set these if you want nixd to understand your system/home configs:
      # flake-path = toString ./.;
      # systemCFGname = "yourHostname";
      # homeCFGname = "yourUsername";
    };
    lspDebugMode = false;
  };

  # Helper to build plugins from flake inputs named "plugins-<name>"
  options.nvim-lib.neovimPlugins = lib.mkOption {
    readOnly = true;
    type = lib.types.attrsOf wlib.types.stringable;
    default = config.nvim-lib.pluginsFromPrefix "plugins-" inputs;
  };
  options.nvim-lib.pluginsFromPrefix = lib.mkOption {
    type = lib.types.raw;
    readOnly = true;
    default =
      prefix: srcs:
      lib.pipe srcs [
        builtins.attrNames
        (builtins.filter (s: lib.hasPrefix prefix s))
        (map (input:
          let name = lib.removePrefix prefix input;
          in { inherit name; value = config.nvim-lib.mkPlugin name srcs.${input}; }))
        builtins.listToAttrs
      ];
  };

  # Add extraPackages field to individual specs, collected into config.extraPackages
  config.specMods = { ... }: {
    options.extraPackages = lib.mkOption {
      type = lib.types.listOf wlib.types.stringable;
      default = [];
    };
  };
  config.extraPackages = config.specCollect (acc: v: acc ++ (v.extraPackages or [])) [];

  # ── Startup plugins (always loaded) ──────────────────────────────────────
  config.specs.startup = {
    data = with pkgs.vimPlugins; [
      lze
      lzextras
      sqlite-lua
      plenary-nvim
      snacks-nvim
      persistence-nvim
      lualine-nvim
      oil-nvim
      # Colorscheme (resolved from settings.colorscheme)
      (builtins.getAttr config.settings.colorscheme {
        "onedark"          = onedark-nvim;
        "catppuccin"       = catppuccin-nvim;
        "catppuccin-mocha" = catppuccin-nvim;
        "tokyonight"       = tokyonight-nvim;
        "tokyonight-day"   = tokyonight-nvim;
        "kanagawa"         = kanagawa-nvim;
      })
    ];
    # Runtime tools always available inside neovim
    extraPackages = with pkgs; [
      universal-ctags
      ripgrep
      fd
      git
      nerd-fonts.jetbrains-mono
      imagemagick
      _1password-cli
      # LSP servers
      typescript-language-server
      vscode-langservers-extracted
      emmet-ls
      gopls
      nixd
      nixfmt-rfc-style
      lua-language-server
      rust-analyzer
      basedpyright
      ruff
      bash-language-server
      fish-lsp
      intelephense
    ];
  };

  # ── Optional plugins (lazy loaded via lze/packadd) ────────────────────────
  config.specs.general = {
    lazy = true;
    data = with pkgs.vimPlugins; [
      mini-nvim
      SchemaStore-nvim
      config.nvim-lib.neovimPlugins.ts-error-translator-nvim
      nvim-lspconfig
      nvim-nio
      promise-async
      # cmp
      blink-cmp
      luasnip
      # treesitter
      nvim-treesitter-context
      nvim-treesitter-textobjects
      nvim-ts-context-commentstring
      nvim-treesitter.withAllGrammars
      # extra
      git-blame-nvim
      nvim-ufo
      which-key-nvim
      undotree
      vim-startuptime
    ];
  };

  # ── Debug plugins ─────────────────────────────────────────────────────────
  config.specs.debug = {
    lazy = true;
    data = with pkgs.vimPlugins; [
      nvim-dap
      nvim-dap-ui
      nvim-dap-virtual-text
      config.nvim-lib.neovimPlugins.nvim-dap-ruby
    ];
    extraPackages = with pkgs; [
      vscode-extensions.xdebug.php-debug
    ];
  };
}


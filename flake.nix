{
  description = "Fire Neovim config with NixCats";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    # Plugins that are not in nixpkgs
    ts-error-translator-nvim = {
      url = "github:dmmulroy/ts-error-translator.nvim";
      flake = false;
    };
    nvim-dap-ruby = {
      url = "github:suketa/nvim-dap-ruby";
      flake = false;
    };
  };

  # see :help nixCats.flake.outputs
  outputs = { self, nixpkgs, ... }@inputs: let
    inherit (inputs.nixCats) utils;
    luaPath = "${./.}";
    forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
    # the following extra_pkg_config contains any values
    # which you want to pass to the config set of nixpkgs
    # import nixpkgs { config = extra_pkg_config; inherit system; }
    # will not apply to module imports
    # as that will have your system values
    extra_pkg_config = {
      allowUnfree = true;
    };
    # management of the system variable is one of the harder parts of using flakes.

    # so I have done it here in an interesting way to keep it out of the way.
    # It gets resolved within the builder itself, and then passed to your
    # categoryDefinitions and packageDefinitions.

    # this allows you to use ${pkgs.system} whenever you want in those sections
    # without fear.

    # sometimes our overlays require a ${system} to access the overlay.
    # Your dependencyOverlays can either be lists
    # in a set of ${system}, or simply a list.
    # the nixCats builder function will accept either.
    # see :help nixCats.flake.outputs.overlays
    dependencyOverlays = /* (import ./overlays inputs) ++ */ [
      # This overlay grabs all the inputs named in the format
      # `plugins-<pluginName>`
      # Once we add this overlay to our nixpkgs, we are able to
      # use `pkgs.neovimPlugins`, which is a set of our plugins.
      (utils.standardPluginOverlay inputs)
      # add any other flake overlays here.

      # when other people mess up their overlays by wrapping them with system,
      # you may instead call this function on their overlay.
      # it will check if it has the system in the set, and if so return the desired overlay
      # (utils.fixSystemizedOverlay inputs.codeium.overlays
      #   (system: inputs.codeium.overlays.${system}.default)
      # )
    ];

    # see :help nixCats.flake.outputs.categories
    # and
    # :help nixCats.flake.outputs.categoryDefinitions.scheme
    categoryDefinitions = { pkgs, settings, categories, extra, name, mkNvimPlugin, ... }@packageDef: {
      # to define and use a new category, simply add a new list to a set here,
      # and later, you will include categoryname = true; in the set you
      # provide when you build the package using this builder function.
      # see :help nixCats.flake.outputs.packageDefinitions for info on that section.

      # lspsAndRuntimeDeps:
      # this section is for dependencies that should be available
      # at RUN TIME for plugins. Will be available to PATH within neovim terminal
      # this includes LSPs
      lspsAndRuntimeDeps = {
        general = with pkgs; [
          universal-ctags
          ripgrep
          fd
          git
          nerd-fonts.jetbrains-mono
          imagemagick
          _1password-cli
        ];
      };

      # This is for plugins that will load at startup without using packadd:
      startupPlugins = {
        general = with pkgs.vimPlugins; {
          always = [
            lze
            lzextras
            sqlite-lua
            plenary-nvim
            snacks-nvim
            persistence-nvim
            lualine-nvim
          ];
        };
        # You can retreive information from the
        # packageDefinitions of the package this was packaged with.
        # :help nixCats.flake.outputs.categoryDefinitions.scheme
        themer = with pkgs.vimPlugins;
          (builtins.getAttr (categories.colorscheme or "kanagawa") {
              # Theme switcher without creating a new category
              "onedark" = onedark-nvim;
              "catppuccin" = catppuccin-nvim;
              "catppuccin-mocha" = catppuccin-nvim;
              "okyonight" = tokyonight-nvim;
              "tokyonight-day" = tokyonight-nvim;
              "kanagawa" = kanagawa-nvim;
            }
          );
      };

      # not loaded automatically at startup.
      optionalPlugins = {
        debug = with pkgs.vimPlugins; {
          default = [
            nvim-dap
            nvim-dap-ui
            nvim-dap-virtual-text
          ];
          ruby = [
            (mkNvimPlugin inputs.nvim-dap-ruby "nvim-dap-ruby")
          ];
        };
        general = {
          cmp = with pkgs.vimPlugins; [
            # cmp stuff
            blink-cmp
            luasnip
          ];
          treesitter = with pkgs.vimPlugins; [
            nvim-treesitter-context
            nvim-treesitter-textobjects
            nvim-ts-context-commentstring
            nvim-treesitter.withAllGrammars
          ];
          always = with pkgs.vimPlugins; [
            mini-nvim
            lazy-lsp-nvim
            SchemaStore-nvim
            (mkNvimPlugin inputs.ts-error-translator-nvim "ts-error-translator.nvim")
            nvim-lspconfig
            nvim-nio
            promise-async
          ];
          extra = with pkgs.vimPlugins; [
            git-blame-nvim
            nvim-ufo
            which-key-nvim
            undotree
            vim-startuptime
            # If it was included in your flake inputs as plugins-hlargs,
            # this would be how to add that plugin in your config.
            # pkgs.neovimPlugins.hlargs
          ];
        };
      };

      # shared libraries to be added to LD_LIBRARY_PATH
      # variable available to nvim runtime
      sharedLibraries = {
        general = with pkgs; [ # <- this would be included if any of the subcategories of general are
          # libgit2
        ];
      };

      # environmentVariables:
      # this section is for environmentVariables that should be available
      # at RUN TIME for plugins. Will be available to path within neovim terminal
      environmentVariables = {
        debug = {
          php = {
            XDEBUG_PATH = pkgs.vscode-extensions.xdebug.php-debug;
          };
        };
      };

      # If you know what these are, you can provide custom ones by category here.
      # If you dont, check this link out:
      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
      extraWrapperArgs = {
        # test = [
        #   '' --set CATTESTVAR2 "It worked again!"''
        # ];
      };

      # lists of the functions you would have passed to
      # python.withPackages or lua.withPackages

      # get the path to this python environment
      # in your lua config via
      # vim.g.python3_host_prog
      # or run from nvim terminal via :!<packagename>-python3
      python3.libraries = {
        # test = (_:[]);
      };
      # populates $LUA_PATH and $LUA_CPATH
      extraLuaPackages = {
        general = [ (_:[]) ];
      };

      # this will enable debug.default if any other subcategory of debug is enabled
      # this is what makes the "default" category special
      # WARNING: use of categories argument in this set will cause infinite recursion
      extraCats = {
        debug = [
          [ "debug" "default" ]
        ];
        php = [
          [ "debug" "php" ]
        ];
        ruby = [
          [ "debug" "ruby" ]
        ];
      };
    };

    # Now build a package with specific categories from above
    # All categories you wish to include must be marked true,
    # but false may be omitted.
    # This entire set is also passed to nixCats for querying within the lua.
    # It is directly translated to a Lua table, and a get function is defined.
    # The get function is to prevent errors when querying subcategories.

    # see :help nixCats.flake.outputs.packageDefinitions
    packageDefinitions = {
      # the name here is the name of the package
      # and also the default command name for it.
      nvim = { pkgs, ... }@misc: {
        # these also recieve our pkgs variable
        # see :help nixCats.flake.outputs.packageDefinitions
        settings = {
          aliases = [ "nv" ];

          # explained below in the `regularCats` package's definition
          # OR see :help nixCats.flake.outputs.settings for all of the settings available
          wrapRc = true;
          configDirName = "nixCats-nvim";
          # neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
        };
        # enable the categories you want from categoryDefinitions
        categories = {
          general = true;
          debug.php = true;
          debug.ruby = true;
          lspDebugMode = false;
          themer = true;
          colorscheme = "kanagawa";
        };
        extra = {
          # to keep the categories table from being filled with non category things that you want to pass
          # there is also an extra table you can use to pass extra stuff.
          # but you can pass all the same stuff in any of these sets and access it in lua
          nixdExtras = {
            nixpkgs = nixpkgs;
          };
        };
      };
      regularCats = { pkgs, ... }@misc: {
        settings = {
          # IMPURE PACKAGE: normal config reload
          # include same categories as main config,
          # will load from vim.fn.stdpath('config')
          wrapRc = false;
          # or tell it some other place to load
          # unwrappedCfgPath = "/some/path/to/your/config";

          # configDirName: will now look for nixCats-nvim within .config and .local and others
          # this can be changed so that you can choose which ones share data folders for auths
          # :h $NVIM_APPNAME
          configDirName = "nixCats-nvim";

          aliases = [ "testCat" ];
        };
        categories = {
          general.always = true;
          general.treesitter = true;
          lspDebugMode = false;
          themer = true;
          colorscheme = "kanagawa";
        };
        extra = {
          nixdExtras = {
            nixpkgs = nixpkgs;
          };
        };
      };
    };

    defaultPackageName = "nvim";
  in

  # see :help nixCats.flake.outputs.exports
  forEachSystem (system: let
    # and this will be our builder! it takes a name from our packageDefinitions as an argument, and builds an nvim.
    nixCatsBuilder = utils.baseBuilder luaPath {
      # we pass in the things to make a pkgs variable to build nvim with later
      inherit nixpkgs system dependencyOverlays extra_pkg_config;
      # and also our categoryDefinitions and packageDefinitions
    } categoryDefinitions packageDefinitions;
    # call it with our defaultPackageName
    defaultPackage = nixCatsBuilder defaultPackageName;

    # this pkgs variable is just for using utils such as pkgs.mkShell
    # within this outputs set.
    pkgs = import nixpkgs { inherit system; };
    # The one used to build neovim is resolved inside the builder
    # and is passed to our categoryDefinitions and packageDefinitions
  in {
    # these outputs will be wrapped with ${system} by utils.eachSystem

    # this will generate a set of all the packages
    # in the packageDefinitions defined above
    # from the package we give it.
    # and additionally output the original as default.
    packages = utils.mkAllWithDefault defaultPackage;

    # choose your package for devShell
    # and add whatever else you want in it.
    devShells = {
      default = pkgs.mkShell {
        name = defaultPackageName;
        packages = [ defaultPackage ];
        inputsFrom = [ ];
        shellHook = ''
        '';
      };
    };

  }) // (let
    # we also export a nixos module to allow reconfiguration from configuration.nix
    nixosModule = utils.mkNixosModules {
      inherit defaultPackageName dependencyOverlays luaPath
        categoryDefinitions packageDefinitions extra_pkg_config nixpkgs;
    };
    # and the same for home manager
    homeModule = utils.mkHomeModules {
      inherit defaultPackageName dependencyOverlays luaPath
        categoryDefinitions packageDefinitions extra_pkg_config nixpkgs;
    };
  in {

    # these outputs will be NOT wrapped with ${system}

    # this will make an overlay out of each of the packageDefinitions defined above
    # and set the default overlay to the one named here.
    overlays = utils.makeOverlays luaPath {
      inherit nixpkgs dependencyOverlays extra_pkg_config;
    } categoryDefinitions packageDefinitions defaultPackageName;

    nixosModules.default = nixosModule;
    homeModules.default = homeModule;

    inherit utils nixosModule homeModule;
    inherit (utils) templates;
  });

}

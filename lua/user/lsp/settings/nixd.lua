local nixd = {
  settings = {
    nixd = {
      nixpkgs = {
        -- nixd requires some configuration in flake based configs.
        -- luckily, the nixCats plugin is here to pass whatever we need!
        -- we passed this in via the `extra` table in our packageDefinitions
        -- for additional configuration options, refer to:
        -- https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md
        expr = [[import (builtins.getFlake "]] .. nixCats.extra("nixdExtras.nixpkgs") .. [[") { }   ]],
      },
      formatting = {
        command = { "nixfmt" }
      },
      diagnostic = {
        suppress = {
          "sema-escaping-with"
        }
      }
    }
  }
}

if nixCats.extra("nixdExtras.flake-path") then
  local flakePath = nixCats.extra("nixdExtras.flake-path")
  if nixCats.extra("nixdExtras.systemCFGname") then
    -- (builtins.getFlake "<path_to_system_flake>").nixosConfigurations."<name>".options
    nixd.settings.nixd.options.nixos = {
      expr = [[(builtins.getFlake "]] .. flakePath ..  [[").nixosConfigurations."]] ..
        nixCats.extra("nixdExtras.systemCFGname") .. [[".options]]
    }
  end
  if nixCats.extra("nixdExtras.homeCFGname") then
    -- (builtins.getFlake "<path_to_system_flake>").homeConfigurations."<name>".options
    nixd.settings.nixd.options["home-manager"] = {
      expr = [[(builtins.getFlake "]] .. flakePath .. [[").homeConfigurations."]]
        .. nixCats.extra("nixdExtras.homeCFGname") .. [[".options]]
    }
  end
end

return nixd

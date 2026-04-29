local nixd = {
  settings = {
    nixd = {
      nixpkgs = {
        -- nixd requires the nixpkgs path. We pass it via info.nixdExtras.nixpkgs in module.nix.
        expr = [[import (builtins.getFlake "]] .. nixInfo("", "info", "nixdExtras", "nixpkgs") .. [[") { }]],
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

local flakePath = nixInfo(nil, "info", "nixdExtras", "flake-path")
if flakePath then
  local systemCFGname = nixInfo(nil, "info", "nixdExtras", "systemCFGname")
  if systemCFGname then
    nixd.settings.nixd.options = nixd.settings.nixd.options or {}
    nixd.settings.nixd.options.nixos = {
      expr = [[(builtins.getFlake "]] .. flakePath .. [[").nixosConfigurations."]] ..
        systemCFGname .. [[".options]]
    }
  end
  local homeCFGname = nixInfo(nil, "info", "nixdExtras", "homeCFGname")
  if homeCFGname then
    nixd.settings.nixd.options = nixd.settings.nixd.options or {}
    nixd.settings.nixd.options["home-manager"] = {
      expr = [[(builtins.getFlake "]] .. flakePath .. [[").homeConfigurations."]] ..
        homeCFGname .. [[".options]]
    }
  end
end

return nixd

local M = {}
M.for_cat = {
    spec_field = "for_cat",
    set_lazy = false,
    modify = function(plugin)
        if type(plugin.for_cat) == "string" then
            plugin.enabled = nixInfo(false, "settings", "cats", plugin.for_cat)
        end
        return plugin
    end,
}

return M

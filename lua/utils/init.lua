-- Tip: whenever you see `LazyVim.` in a source file of the LazyVim distribution
-- by folke, it seems to be defined in the LazyVim source file:
-- `LazyVim/lua/lazyvim/util/init.lua`
--
-- I made the LazyVim utils available everywhere by defining the following in my
-- `init.lua`:
-- _G.LazyVim = require 'utils.init'

---@field root lazyvim.util.root
local M = {}

-- Get the config of a plugin (installed by lazy.nvim)
-- LazyVim https://github.com/LazyVim/LazyVim/blob/ec5981dfb1222c3bf246d9bcaa713d5cfa486fbd/lua/lazyvim/util/init.lua#L41
---@param name string
function M.get_plugin(name)
  return require('lazy.core.config').spec.plugins[name]
end

-- Check if a certain plugin is installed (by lazy.nvim)
-- LazyVim https://github.com/LazyVim/LazyVim/blob/ec5981dfb1222c3bf246d9bcaa713d5cfa486fbd/lua/lazyvim/util/init.lua#L54
---@param plugin string
function M.has(plugin)
  return M.get_plugin(plugin) ~= nil
end

-- Get the options of a plugin (installed by lazy.nvim)
-- LazyVim: https://github.com/LazyVim/LazyVim/blob/ec5981dfb1222c3bf246d9bcaa713d5cfa486fbd/lua/lazyvim/util/init.lua#L119
---@param name string
function M.opts(name)
  local plugin = M.get_plugin(name)
  if not plugin then
    return {}
  end
  local Plugin = require 'lazy.core.plugin'
  return Plugin.values(plugin, 'opts', false)
end

-- Originally:  LazyVim.lua.lazyvim.util.lsp.lua > M.get_raw_config
-- https://github.com/LazyVim/LazyVim/blob/ec5981dfb1222c3bf246d9bcaa713d5cfa486fbd/lua/lazyvim/util/lsp.lua#L128
local lsp = {
  get_raw_config = function(server)
    local ok, ret = pcall(require, 'lspconfig.configs.' .. server)
    if ok then
      return ret
    end
    return require('lspconfig.server_configurations.' .. server)
  end,
}

M.lsp = lsp

return M

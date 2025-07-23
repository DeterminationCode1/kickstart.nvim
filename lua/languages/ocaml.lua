-- LazyVim https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/ocaml.lua
--
--
-- <><> ocp-indent.1.8.1 installed successfully ><><><><><><><><><><><><><><><>  🐫
-- => This package requires additional configuration for use in editors. Install package 'user-setup', or manually:

--    * for Emacs, add these lines to ~/.emacs:
--      (add-to-list 'load-path "/Users/main/.opam/5.3.0/share/emacs/site-lisp")
--      (require 'ocp-indent)

--    * for Vim, add this line to ~/.vimrc:
--      set rtp^="/Users/main/.opam/5.3.0/share/ocp-indent/vim"
return {
  -- recommended = function()
  --   return LazyVim.extras.wants {
  --     ft = { 'ml', 'mli', 'cmi', 'cmo', 'cmx', 'cma', 'cmxa', 'cmxs', 'cmt', 'cmti', 'opam' },
  --     root = { 'merlin.opam', 'dune-project' },
  --   }
  -- end,
  --
  -- =============================== Treesitter ============================
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      if type(opts.ensure_installed) == 'table' then
        vim.list_extend(opts.ensure_installed, { 'ocaml' })
      end
    end,
  },
  -- =============================== LSP ===================================
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        ocamllsp = {
          filetypes = {
            'ocaml',
            'ocaml.menhir',
            'ocaml.interface',
            'ocaml.ocamllex',
            'reason',
            'dune',
          },
          root_dir = function(fname)
            return require('lspconfig.util').root_pattern('*.opam', 'esy.json', 'package.json', '.git', 'dune-project', 'dune-workspace', '*.ml')(fname)
          end,
        },
      },
    },
  },
  -- =============================== Formatter ==============================
  {
    'stevearc/conform.nvim',
    opts = function(_, opts)
      if type(opts.formatters_by_ft) == 'table' then
        -- OCaml uses .ml extension
        vim.list_extend(opts.formatters_by_ft, { ocaml = { 'ocamlformat' } })
      else
        return { formatters_by_ft = {
          ocaml = { 'ocamlformat' },
        } }
      end
    end,
  },
  -- ============================ install cli tools ==========================
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = {
      ensure_installed = {
        'ocamllsp', -- LSP -- WARNING: even though it's the right lsp, Mason
        -- fails to install it. It seems like I have to install it via opam in
        -- the mean time
        'ocamlformat', -- formatter
        -- 'ocamlearlybird' -- debugger
      },
    },
    -- opts = function(_, opts)
    --   if type(opts.ensure_installed) == 'table' then
    --     vim.list_extend(opts.ensure_installed, { 'ocamlformat' })
    --   else
    --     return { ensure_installed = { 'ocamlformat' } }
    --   end
    -- end,
  },
}

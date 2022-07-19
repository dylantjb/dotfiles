-- general
lvim.log.level = "warn"
lvim.colorscheme = "onedarker"
lvim.transparent_window = true
lvim.format_on_save = false
lvim.lint_on_save = true

-- options
vim.opt.timeoutlen = 500
vim.opt.relativenumber = true
lvim.builtin.alpha.active = true
lvim.builtin.terminal.active = true
lvim.lsp.diagnostics.virtual_text = false
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.filters.dotfiles = true
lvim.builtin.nvimtree.setup.renderer.icons.show.git = true

-- treesitter
lvim.builtin.treesitter.ensure_installed = { "norg", "norg_meta", "norg_table", "cpp", "c", "javascript", "markdown" }
lvim.builtin.treesitter.highlight.enabled = true

-- which key
lvim.builtin.which_key.setup.window = { padding = { 0, 0, 0, 0 } }
lvim.builtin.which_key.setup.layout = {
  spacing = 3,
  align = "left",
  height = { min = 1, max = 10 }
}

local formatters = require "lvim.lsp.null-ls.formatters"
local linters = require "lvim.lsp.null-ls.linters"
formatters.setup {
  { exe = "black", filetypes = { "python" } },
  { exe = "isort", filetypes = { "python" } },
  { exe = "scalafmt", filetypes = { "scala" } },
  { exe = "clang-format", filetypes = { "cpp", "c" } },
}
linters.setup {
  { exe = "pylint", filetypes = { "python" } },
  { exe = "cppcheck", filetypes = { "cpp", "c" } },
}

local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()
parser_configs.norg_meta = {
  install_info = {
    url = "https://github.com/nvim-neorg/tree-sitter-norg-meta",
    files = { "src/parser.c" },
    branch = "main"
  },
}
parser_configs.norg_table = {
  install_info = {
    url = "https://github.com/nvim-neorg/tree-sitter-norg-table",
    files = { "src/parser.c" },
    branch = "main"
  },
}

-- additional plugins
lvim.plugins = {
  {
    "lukas-reineke/indent-blankline.nvim",
    setup = function()
      vim.opt.list = true
      vim.g.indentLine_enabled = 1
      vim.g.indent_blankline_buftype_exclude = { "terminal" }
      vim.g.indent_blankline_filetype_exclude = { "help", "terminal", "alpha" }
      vim.g.indent_blankline_show_trailing_blankline_indent = false
      vim.g.indent_blankline_show_first_indent_level = false
    end,
    config = function()
      require("indent_blankline").setup {
        space_char_blankline = " ",
        show_current_context = true,
        show_current_context_start = true,
      }
    end,
  },
  {
    "karb94/neoscroll.nvim",
    event = "BufRead",
    config = function()
      require("neoscroll").setup {
        mappings = { "<C-u>", "<C-d>", "<C-b>", "zt", "zz", "zb" },
        hide_cursor = true,
        stop_eof = true,
        use_local_scrolloff = false,
        respect_scrolloff = false,
        cursor_scrolls_alone = false,
        easing_function = nil,
      }
    end
  },
  {
    "tzachar/cmp-tabnine",
    config = function()
      local tabnine = require "cmp_tabnine.config"
      tabnine:setup {
        max_lines = 1000,
        max_num_results = 20,
        sort = true,
      }
    end,
    run = "./install.sh",
    requires = "hrsh7th/nvim-cmp"
  },
  {
    "windwp/nvim-spectre",
    event = "BufRead",
    config = function()
      require("user.spectre").config()
    end
  },
  {
    "folke/persistence.nvim",
    event = "VimEnter",
    module = "persistence",
    config = function()
      require("persistence").setup {
        dir = vim.fn.expand(vim.fn.stdpath "config" .. "/session/"),
        options = { "buffers", "curdir", "tabpages", "winsize" }
      }
    end,
  },
  {
    "Pocco81/AutoSave.nvim",
    config = function()
      require("autosave").setup()
    end
  },
  { 'TimUntersberger/neogit', requires = 'nvim-lua/plenary.nvim' },
  {
    "nvim-neorg/neorg",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require('neorg').setup {
        load = {
          ["core.defaults"] = {},
          ["core.norg.concealer"] = {},
          ["core.norg.dirman"] = {
            config = {
              workspaces = {
                work = "~/Documents/work",
                home = "~/Documents/home",
              }
            }
          }
        }
      }
    end
  }
}

-- {
--   "scalameta/nvim-metals",
--   config = function()
--     require("user.metals").config()
--   end,
-- },

-- lvim.autocommands.custom_groups = {
--   { "FileType", "scala,sbt", "lua require('user.metals').config()" }
-- }

lvim.builtin.alpha.dashboard.section.header.val = {
  "   ⣴⣶⣤⡤⠦⣤⣀⣤⠆     ⣈⣭⣿⣶⣿⣦⣼⣆          ",
  "    ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠄⡠⢾⣿⣿⡿⠋⠉⠉⠻⣿⣿⡛⣦       ",
  "          ⠈⢿⣿⣟⠦ ⣾⣿⣿⣷    ⠻⠿⢿⣿⣧⣄     ",
  "           ⣸⣿⣿⢧ ⢻⠻⣿⣿⣷⣄⣀⠄⠢⣀⡀⠈⠙⠿⠄    ",
  "          ⢠⣿⣿⣿⠈    ⣻⣿⣿⣿⣿⣿⣿⣿⣛⣳⣤⣀⣀   ",
  "   ⢠⣧⣶⣥⡤⢄ ⣸⣿⣿⠘  ⢀⣴⣿⣿⡿⠛⣿⣿⣧⠈⢿⠿⠟⠛⠻⠿⠄  ",
  "  ⣰⣿⣿⠛⠻⣿⣿⡦⢹⣿⣷   ⢊⣿⣿⡏  ⢸⣿⣿⡇ ⢀⣠⣄⣾⠄   ",
  " ⣠⣿⠿⠛ ⢀⣿⣿⣷⠘⢿⣿⣦⡀ ⢸⢿⣿⣿⣄ ⣸⣿⣿⡇⣪⣿⡿⠿⣿⣷⡄  ",
  " ⠙⠃   ⣼⣿⡟  ⠈⠻⣿⣿⣦⣌⡇⠻⣿⣿⣷⣿⣿⣿ ⣿⣿⡇ ⠛⠻⢷⣄ ",
  "     ⠻⣿⣿⣿⣿⣶  ⠈⠻⣿⣿⣿⣷⣿⣿⣿⣿⣿⡟⣤⣾⡿⠃     ",
}


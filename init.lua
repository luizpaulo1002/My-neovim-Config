-- ============================================================================
-- CONFIGURAÇÃO NEOVIM - C/C++/Java/Python (Embarcados & Machine Learning)
-- Versão Minimalista sem Ícones
-- ============================================================================

-- Configurações Básicas
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.mouse = "a"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.wrap = false
vim.opt.breakindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.clipboard = "unnamedplus"
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.cursorline = true

-- Diretório padrão
vim.cmd('cd /home/luiz/dev')

-- Terminal externo padrão (Kitty)
vim.g.terminal_emulator = 'kitty'

-- Bootstrap do Lazy.nvim (gerenciador de plugins)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
  end
  vim.opt.rtp:prepend(lazypath)

  -- Plugins
  require("lazy").setup({
    -- Tema VSCode
    {
      "Mofiqul/vscode.nvim",
      priority = 1000,
      config = function()
      require('vscode').setup({
        transparent = false,
        italic_comments = true
      })
      vim.cmd.colorscheme('vscode')
      end,
    },

    -- File Explorer (netrw nativo melhorado)
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
    require("nvim-tree").setup({
      view = {
        width = 30,
      },
      renderer = {
        icons = {
          show = {
            file = false,
            folder = false,
            folder_arrow = true,
            git = false,
          },
        },
        indent_markers = { enable = true },
      },
      filters = {
        dotfiles = false,
      },
      actions = {
        open_file = {
          quit_on_open = true,  -- Fecha o tree ao abrir arquivo
        },
      },
      sync_root_with_cwd = true,  -- Sincroniza o root com o diretório atual
      respect_buf_cwd = true,      -- Respeita mudanças de diretório
      update_focused_file = {
        enable = true,             -- Atualiza quando muda de arquivo
        update_root = true,        -- Atualiza o root também
      },
    })

    -- Mapear setas para navegação dentro do nvim-tree
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "NvimTree",
      callback = function()
      local bufnr = vim.api.nvim_get_current_buf()
      local api = require('nvim-tree.api')

      vim.keymap.set('n', '<Up>', 'k', { buffer = bufnr, desc = "Subir no tree" })
      vim.keymap.set('n', '<Down>', 'j', { buffer = bufnr, desc = "Descer no tree" })
      vim.keymap.set('n', '<Left>', 'h', { buffer = bufnr, desc = "Fechar pasta" })

      -- Seta direita: entra no diretório (muda root)
    vim.keymap.set('n', '<Right>', function()
    local node = api.tree.get_node_under_cursor()
    if node and node.type == 'directory' then
      api.tree.change_root_to_node(node)
      else
        vim.cmd('normal! l')
        end
        end, { buffer = bufnr, desc = "Entrar no diretório" })

    -- Enter: entra no diretório OU abre arquivo
    vim.keymap.set('n', '<CR>', function()
    local node = api.tree.get_node_under_cursor()
    if node and node.type == 'directory' then
      api.tree.change_root_to_node(node)
      else
        api.node.open.edit()
        end
        end, { buffer = bufnr, desc = "Entrar em diretório ou abrir arquivo" })
    end,
    })
    end,
  },

  -- Lualine (statusline minimalista)
  {
    "nvim-lualine/lualine.nvim",
    config = function()
    require('lualine').setup({
      options = {
        theme = 'vscode',
        icons_enabled = false,
        component_separators = { left = '|', right = '|'},
        section_separators = { left = '', right = ''},
      },
      sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff'},
        lualine_c = {'filename'},
        lualine_x = {'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
      },
    })
    end,
  },

  -- Treesitter (syntax highlighting)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
    local status_ok, treesitter = pcall(require, 'nvim-treesitter.configs')
    if not status_ok then
      vim.notify("", vim.log.levels.WARN)
      return
      end

      treesitter.setup({
        ensure_installed = { "c", "cpp", "java", "python", "lua", "vim", "vimdoc" },
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
      })
      end,
  },

  -- Mason (gerenciador de LSP)
  {
    "williamboman/mason.nvim",
    config = function()
    require("mason").setup({
      ui = {
        icons = {
          package_installed = "[+]",
          package_pending = "[~]",
          package_uninstalled = "[-]"
        }
      }
    })
    end,
  },

  -- Mason LSP Config
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
    require("mason-lspconfig").setup({
      ensure_installed = { "clangd", "jdtls", "pyright" },
    })
    end,
  },

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
    -- Configuração moderna usando vim.lsp.config
    vim.lsp.config('*', {
      root_markers = { '.git' },
    })

    -- C/C++ (clangd)
  vim.lsp.enable('clangd')

  -- Java (jdtls)
  vim.lsp.enable('jdtls')

  -- Python (pyright)
  vim.lsp.enable('pyright')

  -- Keymaps LSP
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    end,
  })
  end,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')

    cmp.setup({
      snippet = {
        expand = function(args)
        luasnip.lsp_expand(args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
              documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-Space>'] = cmp.mapping.complete(),
                                          ['<CR>'] = cmp.mapping.confirm({ select = true }),
                                          ['<Tab>'] = cmp.mapping(function(fallback)
                                          if cmp.visible() then
                                            cmp.select_next_item()
                                            elseif luasnip.expand_or_jumpable() then
                                              luasnip.expand_or_jump()
                                              else
                                                fallback()
                                                end
                                                end, { 'i', 's' }),
      }),
      sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
      },
      formatting = {
        format = function(entry, item)
          item.menu = ({
            nvim_lsp = "[LSP]",
            luasnip = "[Snip]",
            buffer = "[Buf]",
            path = "[Path]",
          })[entry.source.name]
          return item
          end,
      },
    })
    end,
  },

  -- Telescope (fuzzy finder)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
    require('telescope').setup({
      defaults = {
        prompt_prefix = "> ",
        selection_caret = "> ",
      }
    })
    end,
  },

  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
    require("nvim-autopairs").setup({})
    end,
  },

  -- Comment
  {
    "numToStr/Comment.nvim",
    config = function()
    require('Comment').setup()
    end,
  },

  -- Git integration
  {
    "lewis6991/gitsigns.nvim",
    config = function()
    require('gitsigns').setup({
      signs = {
        add          = { text = '+' },
        change       = { text = '~' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
      },
    })
    end,
  },

  -- Neogit (Git interface estilo Magit)
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
    config = function()
    require('neogit').setup({
      kind = "split",
      graph_style = "unicode",
    })
    end,
  },

  -- Diffview (visualizar diff e histórico)
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
    require('diffview').setup({})
    end,
  },
  })

  -- ============================================================================
  -- ATALHOS PERSONALIZADOS
  -- ============================================================================

  -- Ctrl+S para salvar
  vim.keymap.set({'n', 'i', 'v'}, '<C-s>', '<cmd>w<CR>', { desc = "Salvar arquivo" })

  -- Ctrl+E para explorador de arquivos (toggle sempre)
  vim.keymap.set('n', '<C-e>', function()
  local api = require('nvim-tree.api')
  api.tree.toggle({ focus = false })
  end, { desc = "Abrir/Fechar File Explorer" })

  -- Ctrl+P para buscar arquivos (Telescope)
  vim.keymap.set('n', '<C-p>', '<cmd>Telescope find_files<CR>', { desc = "Buscar arquivos" })

  -- Ctrl+F para buscar texto
  vim.keymap.set('n', '<C-f>', '<cmd>Telescope live_grep<CR>', { desc = "Buscar texto" })

  -- Navegação entre splits/janelas com Alt+Setas
  vim.keymap.set('n', '<A-Left>', '<C-w>h', { desc = "Ir para janela esquerda" })
  vim.keymap.set('n', '<A-Right>', '<C-w>l', { desc = "Ir para janela direita" })
  vim.keymap.set('n', '<A-Down>', '<C-w>j', { desc = "Ir para janela abaixo" })
  vim.keymap.set('n', '<A-Up>', '<C-w>k', { desc = "Ir para janela acima" })

  -- Setas navegam normalmente (cursor/tree)
  vim.keymap.set('n', '<Left>', '<Left>', { desc = "Mover cursor esquerda" })
  vim.keymap.set('n', '<Right>', '<Right>', { desc = "Mover cursor direita" })
  vim.keymap.set('n', '<Down>', '<Down>', { desc = "Mover cursor baixo" })
  vim.keymap.set('n', '<Up>', '<Up>', { desc = "Mover cursor cima" })

  -- Ctrl+/ para comentar
  vim.keymap.set({'n', 'v'}, '<C-_>', '<cmd>lua require("Comment.api").toggle.linewise.current()<CR>', { desc = "Comentar linha" })

  -- Ctrl+T para abrir terminal (Kitty)
  vim.keymap.set('n', '<C-t>', '<cmd>!kitty &<CR><CR>', { desc = "Abrir terminal Kitty" })

  -- Ctrl+O para resetar janela (fechar todos splits e voltar ao padrão)
  vim.keymap.set('n', '<C-o>', function()
  -- Salva todos os arquivos modificados primeiro
  vim.cmd('silent! wall')

  -- Fecha todos os buffers exceto o atual
  vim.cmd('only')

  -- Fecha o tree se estiver aberto
  pcall(vim.cmd, 'NvimTreeClose')

  -- Volta para o diretório padrão
  vim.cmd('cd /home/luiz/dev')

  print('Janela resetada para o padrão!')
  end, { desc = "Resetar janela vim para o padrão" })

  -- Ctrl+X para abrir Git Graph (Neogit)
  vim.keymap.set('n', '<C-x>', function()
  vim.cmd('Neogit')
  end, { desc = "Abrir Git Graph" })

  -- Ctrl+G para abrir Git Diff View
  vim.keymap.set('n', '<C-g>', function()
  vim.cmd('DiffviewOpen')
  end, { desc = "Abrir Git Diff View" })

  -- F2 para atualizar visualização do tree
  vim.keymap.set('n', '<F2>', function()
  local api = require('nvim-tree.api')
  api.tree.reload()
  print('Tree atualizado!')
  end, { desc = "Atualizar visualização do tree" })

  -- ============================================================================
  -- COMPILAÇÃO E EXECUÇÃO (F5/F6)
  -- ============================================================================

  -- F5 - Compilar
  vim.keymap.set('n', '<F5>', function()
  local ft = vim.bo.filetype
  vim.cmd('write')

  if ft == 'c' then
    vim.cmd('!kitty @ launch --type=tab gcc % -o %:r && echo "Compilado com sucesso!"')
    elseif ft == 'cpp' then
      vim.cmd('!kitty @ launch --type=tab g++ -std=c++17 % -o %:r && echo "Compilado com sucesso!"')
      elseif ft == 'java' then
        vim.cmd('!kitty @ launch --type=tab javac % && echo "Compilado com sucesso!"')
        elseif ft == 'python' then
          vim.cmd('!kitty @ launch --type=tab python3 -m py_compile % && echo "Verificado com sucesso!"')
          else
            print("Tipo de arquivo não suportado para compilação")
            end
            end, { desc = "Compilar código" })

  -- F6 - Executar
  vim.keymap.set('n', '<F6>', function()
  local ft = vim.bo.filetype

  if ft == 'c' or ft == 'cpp' then
    vim.cmd('!kitty @ launch --type=tab ./%:r')
    elseif ft == 'java' then
      vim.cmd('!kitty @ launch --type=tab java %:r')
      elseif ft == 'python' then
        vim.cmd('!kitty @ launch --type=tab python3 %')
        else
          print("Tipo de arquivo não suportado para execução")
          end
          end, { desc = "Executar código" })

  -- F7 - Compilar e Executar
  vim.keymap.set('n', '<F7>', function()
  vim.cmd('normal! <F5>')
  vim.defer_fn(function()
  vim.cmd('normal! <F6>')
  end, 500)
  end, { desc = "Compilar e executar" })

  -- ============================================================================
  -- CONFIGURAÇÕES ESPECÍFICAS PARA EMBARCADOS
  -- ============================================================================

  -- Auto-comandos para configurações específicas
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "c",
    callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    end,
  })

  -- ============================================================================
  -- UTILITÁRIOS ADICIONAIS
  -- ============================================================================

  -- Destacar ao copiar
  vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
    vim.highlight.on_yank({ timeout = 200 })
    end,
  })

  -- Remover espaços em branco ao salvar
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    command = [[%s/\s\+$//e]],
  })

  print("Configuração carregada com sucesso!")

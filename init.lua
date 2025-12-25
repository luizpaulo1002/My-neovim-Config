-- CONFIGURAÇÃO NEOVIM - C/C++/Java/Python (Arch Linux)


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
local home = os.getenv("HOME")
local dev_dir = home .. "/dev"

-- Criar diretório se não existir
if vim.fn.isdirectory(dev_dir) == 0 then
  vim.fn.mkdir(dev_dir, "p")
  end

  vim.cmd('cd ' .. dev_dir)

  -- Bootstrap do Lazy.nvim
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

      -- Tema OLED Minimalista (8 cores apenas)
    {
      "olimorris/onedarkpro.nvim",
      priority = 1000,
      config = function()
      require("onedarkpro").setup({
        colors = {
          -- Fundo OLED puro preto
          bg = "#000000",

          -- 8 cores essenciais
          white = "#c0c0c0",
          gray = "#606060",
          red = "#ff5555",
          green = "#50fa7b",
          yellow = "#f1fa8c",
          blue = "#8be9fd",
          magenta = "#ff79c6",
          orange = "#ffb86c",
        },
        highlights = {
          -- Base
          Normal = { fg = "${white}", bg = "${bg}" },
          Comment = { fg = "${gray}", italic = true },

          -- Sintaxe básica
          String = { fg = "${green}" },
          Number = { fg = "${yellow}" },
          Boolean = { fg = "${orange}" },
          Float = { fg = "${yellow}" },

          -- Keywords e controle
          Keyword = { fg = "${blue}" },
          Conditional = { fg = "${magenta}" },
          Repeat = { fg = "${magenta}" },
          Statement = { fg = "${magenta}" },

          -- Tipos e estruturas
          Type = { fg = "${blue}" },
          StorageClass = { fg = "${blue}" },
          Structure = { fg = "${blue}" },

          -- Funções e identificadores
          Function = { fg = "${magenta}" },
          Identifier = { fg = "${white}" },
          Variable = { fg = "${white}" },

          -- Constantes
          Constant = { fg = "${orange}" },
          Character = { fg = "${green}" },

          -- Operadores
          Operator = { fg = "${white}" },
          Delimiter = { fg = "${gray}" },

          -- Especiais
          Special = { fg = "${magenta}" },
          SpecialChar = { fg = "${yellow}" },
          Tag = { fg = "${blue}" },

          -- Diagnósticos
          DiagnosticError = { fg = "${red}" },
          DiagnosticWarn = { fg = "${yellow}" },
          DiagnosticInfo = { fg = "${blue}" },
          DiagnosticHint = { fg = "${gray}" },

          -- Git
          GitSignsAdd = { fg = "${green}" },
          GitSignsChange = { fg = "${yellow}" },
          GitSignsDelete = { fg = "${red}" },

          -- Diff
          DiffAdd = { fg = "${green}" },
          DiffChange = { fg = "${yellow}" },
          DiffDelete = { fg = "${red}" },

          -- UI
          LineNr = { fg = "${gray}" },
          CursorLineNr = { fg = "${white}", bold = true },
          CursorLine = { bg = "#0a0a0a" },
          SignColumn = { bg = "${bg}" },
          StatusLine = { fg = "${white}", bg = "#0a0a0a" },
          Visual = { bg = "#1a1a1a" },
          Pmenu = { fg = "${white}", bg = "#0a0a0a" },
          PmenuSel = { fg = "${bg}", bg = "${blue}" },

          -- LSP Semantic Tokens
          ["@variable"] = { fg = "${white}" },
          ["@variable.builtin"] = { fg = "${blue}" },
          ["@parameter"] = { fg = "${white}" },
          ["@function"] = { fg = "${magenta}" },
          ["@function.builtin"] = { fg = "${magenta}" },
          ["@keyword"] = { fg = "${blue}" },
          ["@keyword.function"] = { fg = "${magenta}" },
          ["@keyword.return"] = { fg = "${magenta}" },
          ["@conditional"] = { fg = "${magenta}" },
          ["@repeat"] = { fg = "${magenta}" },
          ["@type"] = { fg = "${blue}" },
          ["@type.builtin"] = { fg = "${blue}" },
          ["@constant"] = { fg = "${orange}" },
          ["@constant.builtin"] = { fg = "${orange}" },
          ["@string"] = { fg = "${green}" },
          ["@number"] = { fg = "${yellow}" },
          ["@operator"] = { fg = "${white}" },
          ["@punctuation.bracket"] = { fg = "${gray}" },
          ["@punctuation.delimiter"] = { fg = "${gray}" },
        },
        styles = {
          comments = "italic",
          keywords = "NONE",
          functions = "NONE",
          variables = "NONE",
        },
        options = {
          cursorline = true,
          transparency = false,
          terminal_colors = true,
        }
      })
      vim.cmd.colorscheme('onedark_dark')
      end,
    },

    -- File Explorer
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
              folder_arrow = false,
              git = false,
            },
            glyphs = {
              default = "",
              symlink = "",
              folder = {
                default = "[+]",
                open = "[-]",
                empty = "[ ]",
                empty_open = "[ ]",
                symlink = "[L]",
              },
            },
          },
          indent_markers = {
            enable = true,
            icons = {
              corner = "└",
              edge = "│",
              item = "│",
              none = " ",
            },
          },
        },
        filters = {
          dotfiles = false,
        },
        actions = {
          open_file = {
            quit_on_open = true,
          },
        },
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        update_focused_file = {
          enable = true,
          update_root = true,
        },
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "NvimTree",
        callback = function()
        local bufnr = vim.api.nvim_get_current_buf()
        local api = require('nvim-tree.api')

        vim.keymap.set('n', '<Up>', 'k', { buffer = bufnr, desc = "Subir" })
        vim.keymap.set('n', '<Down>', 'j', { buffer = bufnr, desc = "Descer" })

        vim.keymap.set('n', '<Left>', function()
        local node = api.tree.get_node_under_cursor()
        if node and node.type == 'directory' and node.open then
          api.node.open.edit()
          else
            api.tree.change_root_to_parent()
            end
            end, { buffer = bufnr, desc = "Fechar pasta ou voltar" })

        vim.keymap.set('n', '<Right>', function()
        local node = api.tree.get_node_under_cursor()
        if node and node.type == 'directory' then
          if not node.open then
            api.node.open.edit()
            else
              api.tree.change_root_to_node(node)
              end
              else
                api.node.open.edit()
                end
                end, { buffer = bufnr, desc = "Abrir pasta ou entrar" })

        vim.keymap.set('n', '<CR>', function()
        local node = api.tree.get_node_under_cursor()
        if node and node.type == 'directory' then
          api.tree.change_root_to_node(node)
          else
            api.node.open.edit()
            end
            end, { buffer = bufnr, desc = "Abrir" })

        vim.keymap.set('n', '<Delete>', function()
        api.fs.remove()
        end, { buffer = bufnr, desc = "Excluir arquivo/pasta" })

        vim.keymap.set('n', 'd', function()
        api.fs.remove()
        end, { buffer = bufnr, desc = "Excluir arquivo/pasta" })
        end,
      })
      end,
    },

    -- Lualine
    {
      "nvim-lualine/lualine.nvim",
      config = function()
      require('lualine').setup({
        options = {
          theme = 'auto',
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

    -- Mason
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

      vim.lsp.config('*', {
        root_markers = { '.git' },
      })

      vim.lsp.enable('clangd')
      vim.lsp.enable('jdtls')
      vim.lsp.enable('pyright')
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

    -- Telescope
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
      -- Desabilitar auto-comentário na linha seguinte
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "*",
        callback = function()
        vim.opt_local.formatoptions:remove({ 'c', 'r', 'o' })
        end,
      })
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

    -- Neogit
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

    -- Diffview
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

    vim.keymap.set({'n', 'v'}, 'z', 'y', { desc = "Copiar" })
    vim.keymap.set('n', 'zz', 'yy', { desc = "Copiar linha inteira" })
    vim.keymap.set({'n', 'v'}, 'x', 'p', { desc = "Colar" })
    vim.keymap.set({'n', 'i', 'v'}, '<C-s>', '<cmd>w<CR>', { desc = "Salvar arquivo" })

    vim.keymap.set('n', '<C-e>', function()
    local api = require('nvim-tree.api')
    api.tree.toggle({ focus = false })
    end, { desc = "Abrir/Fechar File Explorer" })

    vim.keymap.set('n', '<C-p>', '<cmd>Telescope find_files<CR>', { desc = "Buscar arquivos" })
    vim.keymap.set('n', '<C-f>', '<cmd>Telescope live_grep<CR>', { desc = "Buscar texto" })

    vim.keymap.set('n', '<A-Left>', '<C-w>h', { desc = "Ir para janela esquerda" })
    vim.keymap.set('n', '<A-Right>', '<C-w>l', { desc = "Ir para janela direita" })
    vim.keymap.set('n', '<A-Down>', '<C-w>j', { desc = "Ir para janela abaixo" })
    vim.keymap.set('n', '<A-Up>', '<C-w>k', { desc = "Ir para janela acima" })

    vim.keymap.set('n', '<Left>', '<Left>', { desc = "Mover cursor esquerda" })
    vim.keymap.set('n', '<Right>', '<Right>', { desc = "Mover cursor direita" })
    vim.keymap.set('n', '<Down>', '<Down>', { desc = "Mover cursor baixo" })
    vim.keymap.set('n', '<Up>', '<Up>', { desc = "Mover cursor cima" })

    vim.keymap.set({'n', 'v'}, '<C-_>', function()
    require("Comment.api").toggle.linewise.current()
    end, { desc = "Comentar linha" })

    vim.keymap.set('n', '<C-t>', function()
    local terminal = vim.fn.executable('kitty') == 1 and 'kitty' or
    vim.fn.executable('alacritty') == 1 and 'alacritty' or
    'xterm'
    vim.cmd('!' .. terminal .. ' &')
    end, { desc = "Abrir terminal" })

    vim.keymap.set('n', '<C-o>', function()
    vim.cmd('silent! wall')
    vim.cmd('only')
    pcall(vim.cmd, 'NvimTreeClose')

    local home = os.getenv("HOME")
    local dev_dir = home .. '/dev'

    if vim.fn.isdirectory(dev_dir) == 0 then
      vim.fn.mkdir(dev_dir, "p")
      end

      vim.cmd('cd ' .. dev_dir)
      print('Janela resetada!')
      end, { desc = "Resetar janela" })

    vim.keymap.set('n', '<C-x>', '<cmd>Neogit<CR>', { desc = "Abrir Git Graph" })
    vim.keymap.set('n', '<C-g>', '<cmd>DiffviewOpen<CR>', { desc = "Abrir Git Diff View" })

    vim.keymap.set('n', '<F2>', function()
    local api = require('nvim-tree.api')
    api.tree.reload()
    print('Tree atualizado!')
    end, { desc = "Atualizar tree" })

    -- ============================================================================
    -- COMPILAÇÃO E EXECUÇÃO (F5/F6/F7/F8/F9/F10/F11)
    -- ============================================================================

    local function run_command(cmd)
    vim.cmd('write')
    vim.cmd('botright new')
    local bufnr = vim.api.nvim_get_current_buf()

    vim.fn.termopen(cmd, {
      on_exit = function(_, exit_code)
      vim.schedule(function()
      vim.api.nvim_buf_set_option(bufnr, 'modifiable', true)

      if exit_code == 0 then
        vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, {
          '',
          '─────────────────────────────────',
          '[OK] Processo finalizado com sucesso',
          '─────────────────────────────────',
          '',
          'Pressione <Enter> para fechar ou q para sair'
        })
        else
          vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, {
            '',
            '─────────────────────────────────',
            '[ERRO] Codigo de saida: ' .. exit_code,
            '─────────────────────────────────'
          })
          end

          vim.api.nvim_buf_set_option(bufnr, 'modifiable', false)
          end)
      end
    })

    vim.cmd('startinsert')

    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<CR>', ':q<CR>', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'q', ':q<CR>', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(bufnr, 't', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })
    end

    local function get_output_name()
    return vim.fn.expand('%:r')
    end

    local function get_java_class()
    local filename = vim.fn.expand('%:t:r')
    return filename
    end

    vim.keymap.set('n', '<F5>', function()
    local ft = vim.bo.filetype
    local file = vim.fn.expand('%')
    local output = get_output_name()

    if ft == 'c' then
      print('[COMPILE] Compilando C...')
      run_command('gcc -Wall -Wextra -g ' .. file .. ' -o ' .. output .. ' -lm')

      elseif ft == 'cpp' then
        print('[COMPILE] Compilando C++...')
        run_command('g++ -std=c++17 -Wall -Wextra -g ' .. file .. ' -o ' .. output)

        elseif ft == 'java' then
          print('[COMPILE] Compilando Java...')
          run_command('javac ' .. file)

          elseif ft == 'python' then
            print('[INFO] Python nao precisa compilacao!')
            print('Use F6 para executar ou F7 para executar com verificacao de sintaxe')

            else
              print('[ERRO] Tipo de arquivo nao suportado para compilacao: ' .. ft)
              end
              end, { desc = "Compilar código" })

    vim.keymap.set('n', '<F6>', function()
    local ft = vim.bo.filetype
    local output = get_output_name()
    local file = vim.fn.expand('%')

    if ft == 'c' or ft == 'cpp' then
      if vim.fn.filereadable(output) == 1 then
        print('[RUN] Executando ' .. output .. '...')
        run_command('./' .. output)
        else
          print('[ERRO] Executavel nao encontrado! Use F5 para compilar primeiro.')
          end

          elseif ft == 'java' then
            local class_name = get_java_class()
            local class_file = class_name .. '.class'

    if vim.fn.filereadable(class_file) == 1 then
      print('[RUN] Executando Java...')
      run_command('java ' .. class_name)
      else
        print('[ERRO] Arquivo .class nao encontrado! Use F5 para compilar primeiro.')
        end

        elseif ft == 'python' then
          print('[RUN] Executando Python...')
          run_command('python3 ' .. file)

          else
            print('[ERRO] Tipo de arquivo nao suportado: ' .. ft)
            end
            end, { desc = "Executar código" })

    vim.keymap.set('n', '<F7>', function()
    local ft = vim.bo.filetype
    local file = vim.fn.expand('%')
    local output = get_output_name()

    if ft == 'c' then
      print('[BUILD] Compilando e executando C...')
      run_command('gcc -Wall -Wextra -g ' .. file .. ' -o ' .. output .. ' -lm && ./' .. output)

      elseif ft == 'cpp' then
        print('[BUILD] Compilando e executando C++...')
        run_command('g++ -std=c++17 -Wall -Wextra -g ' .. file .. ' -o ' .. output .. ' && ./' .. output)

        elseif ft == 'java' then
          local class_name = get_java_class()
          print('[BUILD] Compilando e executando Java...')
          run_command('javac ' .. file .. ' && java ' .. class_name)

          elseif ft == 'python' then
            print('[RUN] Executando Python...')
            run_command('python3 ' .. file)

            else
              print('[ERRO] Tipo de arquivo nao suportado: ' .. ft)
              end
              end, { desc = "Compilar e executar" })

    vim.keymap.set('n', '<F8>', function()
    local ft = vim.bo.filetype
    local output = get_output_name()
    local class_name = get_java_class()

    local files_removed = {}

    if ft == 'c' or ft == 'cpp' then
      if vim.fn.filereadable(output) == 1 then
        vim.fn.delete(output)
        table.insert(files_removed, output)
        end

        elseif ft == 'java' then
          local class_files = vim.fn.glob('*.class', false, true)
          for _, file in ipairs(class_files) do
            vim.fn.delete(file)
            table.insert(files_removed, file)
            end

            elseif ft == 'python' then
              local pycache = '__pycache__'
    if vim.fn.isdirectory(pycache) == 1 then
      vim.fn.delete(pycache, 'rf')
      table.insert(files_removed, pycache)
      end

      local pyc_files = vim.fn.glob('*.pyc', false, true)
      for _, file in ipairs(pyc_files) do
        vim.fn.delete(file)
        table.insert(files_removed, file)
        end
        end

        if #files_removed > 0 then
          print('[CLEAN] Arquivos removidos: ' .. table.concat(files_removed, ', '))
          else
            print('[INFO] Nenhum arquivo para limpar')
            end
            end, { desc = "Limpar arquivos compilados" })

    vim.keymap.set('n', '<F9>', function()
    local ft = vim.bo.filetype
    local file = vim.fn.expand('%')
    local output = get_output_name()

    if ft == 'c' then
      print('[RELEASE] Compilando C (Release -O3)...')
      run_command('gcc -O3 -Wall -Wextra ' .. file .. ' -o ' .. output .. ' -lm')

      elseif ft == 'cpp' then
        print('[RELEASE] Compilando C++ (Release -O3)...')
        run_command('g++ -std=c++17 -O3 -Wall -Wextra ' .. file .. ' -o ' .. output)

        else
          print('[ERRO] Otimizacao disponivel apenas para C/C++')
          end
          end, { desc = "Compilar otimizado (Release)" })

    vim.keymap.set('n', '<F10>', function()
    local ft = vim.bo.filetype
    local output = get_output_name()

    if ft == 'c' or ft == 'cpp' then
      if vim.fn.filereadable(output) == 1 then
        print('[VALGRIND] Executando com Valgrind...')
        run_command('valgrind --leak-check=full --show-leak-kinds=all ./' .. output)
        else
          print('[ERRO] Executavel nao encontrado! Compile primeiro (F5)')
          end
          else
            print('[ERRO] Valgrind disponivel apenas para C/C++')
            end
            end, { desc = "Executar com Valgrind" })

    vim.keymap.set('n', '<F11>', function()
    local ft = vim.bo.filetype
    local file = vim.fn.expand('%')
    local output = get_output_name()
    local input_file = 'input.txt'

    if vim.fn.filereadable(input_file) == 0 then
      print('[ERRO] Arquivo input.txt nao encontrado!')
      return
      end

      if ft == 'c' then
        print('[BUILD] Compilando e executando C com input.txt...')
        run_command('gcc -Wall -Wextra -g ' .. file .. ' -o ' .. output .. ' -lm && ./' .. output .. ' < ' .. input_file)

        elseif ft == 'cpp' then
          print('[BUILD] Compilando e executando C++ com input.txt...')
          run_command('g++ -std=c++17 -Wall -Wextra -g ' .. file .. ' -o ' .. output .. ' && ./' .. output .. ' < ' .. input_file)

          elseif ft == 'java' then
            local class_name = get_java_class()
            print('[BUILD] Compilando e executando Java com input.txt...')
            run_command('javac ' .. file .. ' && java ' .. class_name .. ' < ' .. input_file)

            elseif ft == 'python' then
              print('[RUN] Executando Python com input.txt...')
              run_command('python3 ' .. file .. ' < ' .. input_file)

              else
                print('[ERRO] Tipo de arquivo nao suportado: ' .. ft)
                end
                end, { desc = "Executar com input.txt" })

    vim.keymap.set('n', '<leader>ci', function()
    vim.cmd('vsplit input.txt')
    print('[INFO] Arquivo input.txt criado/aberto')
    end, { desc = "Criar/abrir input.txt" })

    vim.keymap.set('n', '<leader>co', function()
    vim.cmd('vsplit output.txt')
    print('[INFO] Arquivo output.txt criado/aberto')
    end, { desc = "Criar/abrir output.txt" })

    -- ============================================================================
    -- UTILITÁRIOS
    -- ============================================================================

    vim.api.nvim_create_autocmd('TextYankPost', {
      callback = function()
      vim.highlight.on_yank({ timeout = 200 })
      end,
    })

    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*",
      command = [[%s/\s\+$//e]],
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "c",
      callback = function()
      vim.opt_local.tabstop = 4
      vim.opt_local.shiftwidth = 4
      end,
    })

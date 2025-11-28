-- Set <space> as the leader key
-- See `:help mapleader`
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '

-- [[ Setting options ]] See `:h vim.o`
-- NOTE: You can change these options as you wish!
-- For more options, you can see `:help option-list`
-- To see documentation for an option, you can use `:h 'optionname'`, for example `:h 'number'`
-- (Note the single quotes)

vim.o.title = true
vim.o.background = 'light'
vim.o.laststatus = 2
vim.o.showmode = false
vim.o.termguicolors = true
vim.cmd.colorscheme('iceberg')

vim.o.autochdir = true

vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true

vim.o.jumpoptions = 'stack'

if vim.fn.has('win32') == 1 then
  vim.o.shell = 'C:/PROGRA~1/Git/usr/bin/bash.exe'
  vim.o.shellcmdflag = '-c'
  vim.o.shellquote = ''
  vim.o.shellxquote = ''
  vim.o.shellslash = true
  vim.env.PATH = vim.env.USERPROFILE .. '/bin;/mingw64/bin;/usr/local/bin;/usr/bin;/bin;' .. vim.env.PATH
  vim.env.BASH_ENV = '~/.bash_aliases'
end

vim.o.undofile = true

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*/.git/*',
  command = 'setlocal noundofile'
})

vim.o.signcolumn = 'yes:1'

-- Print the line number in front of each line
vim.o.number = true

-- Use relative line numbers, so that it is easier to jump with j, k. This will affect the 'number'
-- option above, see `:h number_relativenumber`
vim.o.relativenumber = true

-- Sync clipboard between OS and Neovim. Schedule the setting after `UiEnter` because it can
-- increase startup-time. Remove this option if you want your OS clipboard to remain independent.
-- See `:help 'clipboard'`
-- vim.api.nvim_create_autocmd('UIEnter', {
--   callback = function()
--     vim.o.clipboard = 'unnamedplus'
--   end,
-- })

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Highlight the line where the cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- Show <tab> and trailing spaces
vim.o.list = true

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s) See `:help 'confirm'`
vim.o.confirm = true

-- [[ Set up keymaps ]] See `:h vim.keymap.set()`, `:h mapping`, `:h keycodes`

-- Use <Esc> to exit terminal mode
--vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

-- Map <A-j>, <A-k>, <A-h>, <A-l> to navigate between windows in any modes
vim.keymap.set({ 't', 'i' }, '<A-h>', '<C-\\><C-n><C-w>h')
vim.keymap.set({ 't', 'i' }, '<A-j>', '<C-\\><C-n><C-w>j')
vim.keymap.set({ 't', 'i' }, '<A-k>', '<C-\\><C-n><C-w>k')
vim.keymap.set({ 't', 'i' }, '<A-l>', '<C-\\><C-n><C-w>l')
vim.keymap.set({ 'n' }, '<A-h>', '<C-w>h')
vim.keymap.set({ 'n' }, '<A-j>', '<C-w>j')
vim.keymap.set({ 'n' }, '<A-k>', '<C-w>k')
vim.keymap.set({ 'n' }, '<A-l>', '<C-w>l')

-- [[ Basic Autocommands ]].
-- See `:h lua-guide-autocommands`, `:h autocmd`, `:h nvim_create_autocmd()`

-- Highlight when yanking (copying) text.
-- Try it with `yap` in normal mode. See `:h vim.hl.on_yank()`
if vim.hl ~= nil and vim.hl.on_yank ~= nil then
  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    callback = function()
      vim.hl.on_yank()
    end,
  })
end

-- [[ Create user commands ]]
-- See `:h nvim_create_user_command()` and `:h user-commands`

-- Create a command `:GitBlameLine` that print the git blame for the current line
--vim.api.nvim_create_user_command('GitBlameLine', function()
--  local line_number = vim.fn.line('.') -- Get the current line number. See `:h line()`
--  local filename = vim.api.nvim_buf_get_name(0)
--  print(vim.fn.system({ 'git', 'blame', '-L', line_number .. ',+1', filename }))
--end, { desc = 'Print the git blame for the current line' })

-- [[ Add optional packages ]]
-- Nvim comes bundled with a set of packages that are not enabled by
-- default. You can enable any of them by using the `:packadd` command.

-- For example, to add the "nohlsearch" package to automatically turn off search highlighting after
-- 'updatetime' and when going to insert mode
vim.cmd('silent! packadd! nohlsearch')

vim.cmd('silent! packadd! matchit')

vim.keymap.set('c', '<C-a>', '<Home>')
vim.keymap.set({'n', '!', 't'}, '<S-Insert>', function() vim.api.nvim_paste(vim.fn.getreg('+'), true, -1) end)

require('buffer_switcher')

-- <C-i> won't work after mapping <Tab>
vim.keymap.set('n', '<C-l>', '<C-i>')

require('toggleterm').setup {
  open_mapping = '<C-q>',
  direction = 'float',
}

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

require('gitsigns').setup {
  on_attach = function(bufnr)
    local gitsigns = require('gitsigns')

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal({']c', bang = true})
      else
        gitsigns.nav_hunk('next')
      end
    end)

    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal({'[c', bang = true})
      else
        gitsigns.nav_hunk('prev')
      end
    end)

    -- Actions
    map('n', '<leader>hs', gitsigns.stage_hunk)
    map('n', '<leader>hr', gitsigns.reset_hunk)

    map('v', '<leader>hs', function()
      gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end)

    map('v', '<leader>hr', function()
      gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end)

    map('n', '<leader>hS', gitsigns.stage_buffer)
    map('n', '<leader>hR', gitsigns.reset_buffer)
    map('n', '<leader>hp', gitsigns.preview_hunk)
    map('n', '<leader>hi', gitsigns.preview_hunk_inline)

    map('n', '<leader>hb', function()
      gitsigns.blame_line({ full = true })
    end)

    map('n', '<leader>hd', gitsigns.diffthis)

    map('n', '<leader>hD', function()
      gitsigns.diffthis('~')
    end)

    map('n', '<leader>hQ', function() gitsigns.setqflist('all') end)
    map('n', '<leader>hq', gitsigns.setqflist)

    -- Toggles
    map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
    map('n', '<leader>tw', gitsigns.toggle_word_diff)

    -- Text object
    map({'o', 'x'}, 'ih', gitsigns.select_hunk)
  end
}

vim.keymap.set('n', '<leader>gc', '<cmd>Git commit<CR>')
vim.keymap.set('n', '<leader>ga', '<cmd>Git commit --amend<CR>')
vim.keymap.set('n', '<leader>gl', '<cmd>Git log --decorate --oneline --graph<CR>')
vim.keymap.set('n', '<leader>gs', '<cmd>Git status<CR>')

require('lualine').setup {}

if vim.fn.has('win32') == 1 then
  vim.lsp.config('bashls', {
    cmd = {'bash-language-server.cmd', 'start' },
  })
end

vim.lsp.enable('bashls')

require('trouble').setup {}

vim.keymap.set('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<CR>')
vim.keymap.set('n', '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>')

-- vim: sw=2 sts=2

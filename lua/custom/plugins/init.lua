-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'christoomey/vim-tmux-navigator',
    cmd = {
      'TmuxNavigateLeft',
      'TmuxNavigateDown',
      'TmuxNavigateUp',
      'TmuxNavigateRight',
      'TmuxNavigatePrevious',
      'TmuxNavigatorProcessList',
    },
    -- The plugin shells out via `system()` with shellcmdflag='-c', which cmd.exe (our
    -- Windows 'shell') ignores, so tmux never receives select-pane. Redefine the commands
    -- to run tmux directly (no shell); the plugin's keys/commands/netrw handling stay as-is.
    config = function()
      local flags = { h = '-L', j = '-D', k = '-U', l = '-R', p = '-l' }
      local function navigate(dir)
        local win = vim.api.nvim_get_current_win()
        if dir ~= 'p' then vim.cmd('wincmd ' .. dir) end
        if (dir == 'p' or vim.api.nvim_get_current_win() == win) and vim.env.TMUX then
          vim.fn.jobstart { 'tmux', 'select-pane', '-t', vim.env.TMUX_PANE, flags[dir] }
        end
      end
      local names = { h = 'Left', j = 'Down', k = 'Up', l = 'Right', p = 'Previous' }
      for dir, name in pairs(names) do
        vim.api.nvim_create_user_command('TmuxNavigate' .. name, function() navigate(dir) end, {})
      end
    end,
    keys = {
      { '<c-h>', '<cmd><C-U>TmuxNavigateLeft<cr>' },
      { '<c-j>', '<cmd><C-U>TmuxNavigateDown<cr>' },
      { '<c-k>', '<cmd><C-U>TmuxNavigateUp<cr>' },
      { '<c-l>', '<cmd><C-U>TmuxNavigateRight<cr>' },
      { '<c-\\>', '<cmd><C-U>TmuxNavigatePrevious<cr>' },
    },
  },
}

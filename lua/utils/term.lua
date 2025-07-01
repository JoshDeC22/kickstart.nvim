local M = {}

local function create_term()
  local buf_list = vim.fn.getbufinfo { buflisted = 1 }

  local file_bufs = vim.tbl_filter(function(buf)
    local ft = buf.filetype
    local name = buf.name
    return ft ~= 'neo-tree' and ft ~= 'terminal' and ft ~= 'toggleterm' and not name:match '^term://'
  end, buf_list)
  if #file_bufs >= 1 then
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      local ft = vim.bo[buf].filetype
      local name = vim.fn.bufname(buf)
      if ft == 'toggleterm' or ft == 'terminal' or name:match '^term://' then
        vim.api.nvim_win_close(win, true)
      end
    end

    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      local ft = vim.bo[buf].filetype
      local name = vim.fn.bufname(buf)
      if ft ~= 'neo-tree' and ft ~= 'terminal' and ft ~= 'toggleterm' and not name:match '^term://' then
        vim.api.nvim_set_current_win(win)
        break
      end
    end

    vim.cmd.split()
    vim.cmd.term()
    vim.api.nvim_win_set_height(0, 10)
    vim.cmd.wincmd 'k'
  end
end

function M.open_term()
  create_term()
end

function M.delete_buf(args)
  local current_buf = args.buf
  local all_bufs = vim.fn.getbufinfo { buflisted = 1 }

  local function is_valid(buf)
    local ft = buf.filetype or ''
    local name = buf.name or ''
    return ft ~= 'neo-tree' and ft ~= 'toggleterm' and ft ~= 'terminal' and not name:match '^term://' and name ~= ''
  end

  local real_bufs = vim.tbl_filter(is_valid, all_bufs)

  if #real_bufs == 0 then
    return
  end

  local index = nil
  for i, buf in ipairs(real_bufs) do
    if buf.bufnr == current_buf then
      index = i
      break
    end
  end

  local target = nil
  if index then
    target = real_bufs[index + 1] and real_bufs[index + 1].bufnr or real_bufs[index - 1] and real_bufs[index - 1].bufnr
  else
    target = real_bufs[1].bufnr
  end

  if target and vim.api.nvim_buf_is_loaded(target) then
    vim.schedule(function()
      vim.api.nvim_set_current_buf(target)
      create_term()
    end)
  end
end

return M

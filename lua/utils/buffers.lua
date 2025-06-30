local M = {}

local function is_valid_buffer(buf)
  local ft = vim.bo[buf].filetype
  local name = vim.fn.bufname(buf)
  return vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted and ft ~= 'terminal' and ft ~= 'toggleterm' and not name:match '^term://'
end

function M.next_buffer()
  local current = vim.api.nvim_get_current_buf()
  local buffers = vim.tbl_filter(function(buf)
    return is_valid_buffer(buf)
  end, vim.api.nvim_list_bufs())

  for i, buf in ipairs(buffers) do
    if buf == current then
      local next_buf = buffers[i % #buffers + 1]
      vim.api.nvim_set_current_buf(next_buf)
      return
    end
  end
end

function M.prev_buffer()
  local current = vim.api.nvim_get_current_buf()
  local buffers = vim.tbl_filter(function(buf)
    return is_valid_buffer(buf)
  end, vim.api.nvim_list_bufs())

  for i, buf in ipairs(buffers) do
    if buf == current then
      local prev_buf = buffers[(i - 2 + #buffers) % #buffers + 1]
      vim.api.nvim_set_current_buf(prev_buf)
      return
    end
  end
end

return M

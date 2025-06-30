-- This is the setup for bufferline
return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    require('bufferline').setup {
      options = {
        mode = 'buffers',
        themable = true,
        numbers = 'none',
        close_command = 'bdelete! %d',
        buffer_close_icon = 'x',
        close_icon = 'x',
        modified_icon = '● ',
        left_trunc_marker = ' ',
        right_trunc_marker = ' ',
        max_name_length = 30,
        max_prefix_length = 30,
        tab_size = 21,
        diagnostics = false,
        diagnostics_update_in_insert = false,
        color_icons = true,
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        persist_buffer_sort = true,
        separator_style = { '|', '|' },
        enforce_regular_tabs = true,
        always_show_bufferline = true,
        show_tab_indicators = true,
        indicator = {
          style = 'none',
        },
        sort_by = 'insert_at_end',
        custom_filter = function(buf_number, buf_numbers)
          if string.match(vim.fn.bufname(buf_number), 'term://') then
            return false
          end
          return true
        end,
      },
    }
  end,
}

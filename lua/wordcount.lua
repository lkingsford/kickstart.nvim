local M = {}

function M.count()
  if vim.bo.filetype ~= 'markdown' then
    return ''
  end

  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local count = 0
  local in_comment = false

  for _, line in ipairs(lines) do
    if line:match '^%%' or line:match '^#' or line:match '^>' then
      goto continue
    end

    if line:match '<!--' then
      in_comment = true
    end

    if not in_comment then
      for _ in line:gmatch '%S+' do
        count = count + 1
      end
    end

    if line:match '-->' then
      in_comment = false
    end

    ::continue::
  end

  return 'WC:' .. count
end

return M

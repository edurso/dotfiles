local colorscheme = 'onedark'

local is_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not is_ok then
    vim.notify('colorscheme ' .. colorscheme .. ' not found!')
    return
end

vim.o.background = "dark"
vim.cmd('highlight Normal guibg=NONE ctermbg=NONE')

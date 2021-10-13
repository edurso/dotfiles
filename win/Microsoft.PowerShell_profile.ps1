# PowerShell Configuration File
# Author: @edurso

Invoke-Expression (&starship init powershell)

Set-Alias lg lazygit
Set-Alias np notepad
Set-Alias l ls
Set-Alias vi nvim
Set-Alias vim nvim

function wk {
    Set-Location "D:\workspace"
}


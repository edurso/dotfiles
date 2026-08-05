return {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = true,
    cmd = {
        "ClaudeCode", "ClaudeCodeFocus", "ClaudeCodeSelectModel",
        "ClaudeCodeAdd", "ClaudeCodeSend", "ClaudeCodeTreeAdd",
        "ClaudeCodeStatus", "ClaudeCodeStart", "ClaudeCodeStop",
        "ClaudeCodeOpen", "ClaudeCodeClose", "ClaudeCodeDiffAccept",
        "ClaudeCodeDiffDeny", "ClaudeCodeCloseAllDiffs",
    },
    keys = {
        { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
        { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
        { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume session" },
        { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue session" },
        { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select model" },
        { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
        { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection" },
        { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
        { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
}

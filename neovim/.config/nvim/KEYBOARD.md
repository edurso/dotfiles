# Keyboard Shortcuts

Reference for every custom keybinding in this Neovim config, grouped by functionality.
Generated from the actual `lua/edurso/**` source — if you change a mapping, update this file too.

**Leader key: `,` (comma)** — both `mapleader` and `maplocalleader` (`keymap.lua`).
`timeoutlen = 300ms` — how long Neovim waits after a partial key sequence before firing it (`opts.lua`).

Notation: `<leader>` = `,`. `n`/`i`/`v` = normal/insert/visual mode. A mode letter in `()` means the mapping is buffer-local (only active in that context, e.g. inside neo-tree or after an LSP attaches).

---

## Contents

1. [Editor basics](#editor-basics)
2. [Window / pane navigation](#window--pane-navigation)
3. [Buffers](#buffers)
4. [File explorer (neo-tree)](#file-explorer-neo-tree)
5. [Fuzzy finding (telescope)](#fuzzy-finding-telescope)
6. [LSP](#lsp)
7. [Git (gitsigns + snacks)](#git-gitsigns--snacks)
8. [Diagnostics (trouble)](#diagnostics-trouble)
9. [AI / Claude Code](#ai--claude-code)
10. [Snacks utilities](#snacks-utilities)
11. [Formatting / docstrings / auto-import](#formatting--docstrings--auto-import)
12. [Completion (insert mode)](#completion-insert-mode)
13. [Editing (multi-cursor, surround, comment)](#editing-multi-cursor-surround-comment)
14. [Plugin manager](#plugin-manager)
15. [Quirks & things worth revisiting](#quirks--things-worth-revisiting)

---

## Editor basics

`keymap.lua`

| Key | Mode | Action |
|---|---|---|
| `qq` | n | `:q` |
| `q!` | n | `:q!` |
| `qa` | n | `:qa` |
| `<C-s>` | n | `:wa` (save all buffers) |
| `<Enter>` | n | Insert blank line below, stay in normal mode |
| `<S-Enter>` | n | Insert blank line above, stay in normal mode |

---

## Window / pane navigation

`plugins/smart-splits.lua` — tmux-aware, added so `C-h/j/k/l` works identically whether the next pane over is a Neovim split or a different tmux pane (see `tmux/.tmux.conf`).

| Key | Mode | Action |
|---|---|---|
| `<C-h>` | n | Move focus left (split or tmux pane) |
| `<C-j>` | n | Move focus down |
| `<C-k>` | n | Move focus up |
| `<C-l>` | n | Move focus right |
| `<M-h>` | n | Resize split/pane left |
| `<M-j>` | n | Resize split/pane down |
| `<M-k>` | n | Resize split/pane up |
| `<M-l>` | n | Resize split/pane right |

> Outside Neovim, in a plain tmux pane, these same `C-h/j/k/l` / `M-h/j/k/l` keys move/resize tmux panes directly (`tmux/.tmux.conf`). tmux's own prefix is `` ` `` (backtick), not the default `Ctrl-b`.

---

## Buffers

`plugins/bufferline.lua` (visual bar at the top) + `plugins/snacks.lua` (closing).

| Key | Mode | Action |
|---|---|---|
| `]b` | n | Next buffer |
| `[b` | n | Previous buffer |
| `<leader>1` … `<leader>9` | n | Jump to buffer 1–9 (position in the bufferline bar) |
| `<leader>bp` | n | Pin/unpin current buffer |
| `<leader>bd` | n | Delete (close) current buffer, keeps window layout |
| `<leader>bo` | n | Delete all other buffers |
| `<leader>ba` | n | Delete **all** buffers |
| `<leader><leader>` | n | Telescope: fuzzy-pick an open buffer |
| `fb` | n | Same as above (telescope buffers) |

**Mouse**, on the bufferline bar itself:

| Click | Action |
|---|---|
| The small `x` on an individual tab | Close that specific buffer |
| The `x` at the far right end of the bar | Close the **current** buffer |
| Left-click a tab | Switch to that buffer |

All close actions (keyboard and mouse) route through `Snacks.bufdelete`, so window layout is preserved either way.

---

## File explorer (neo-tree)

`plugins/neo-tree.lua`

| Key | Mode | Action |
|---|---|---|
| `t` | n | Open/reveal neo-tree (global) |
| `t` | n (neo-tree window) | Close the neo-tree window |

Filesystem view shows dotfiles and gitignored files (`filtered_items.visible = true`). Neo-tree's own default keymap set is active for everything else inside the tree (e.g. `a` add file, `d` delete, `r` rename, `y`/`p` copy/paste, `R` refresh) — run `?` inside the tree window to see them all.

---

## Fuzzy finding (telescope)

`plugins/fuzzy.lua`

| Key | Mode | Action |
|---|---|---|
| `<leader>sh` | n | Search help tags |
| `<leader>sk` | n | Search keymaps |
| `<leader>sf` / `ff` | n | Find files |
| `<leader>ss` | n | Search Telescope's own builtin pickers |
| `<leader>sw` | n | Grep the word under the cursor |
| `<leader>sg` / `fg` | n | Live grep |
| `<leader>sd` | n | Search diagnostics |
| `<leader>sr` | n | Resume last search |
| `<leader>s.` | n | Recent files (oldfiles) |
| `<leader>/` | n | Fuzzy search current buffer |
| `<leader>s/` | n | Live grep across all open files |
| `<leader>sn` | n | Search Neovim config files |

Inside any Telescope prompt: `<C-/>` (insert mode) / `?` (normal mode) shows that picker's own keymaps.

---

## LSP

`plugins/lsp.lua` — mappings are buffer-local, set only after an LSP client attaches to that buffer. Many have a duplicate function-key binding for mouse-free/muscle-memory use.

| Key | Function key | Action |
|---|---|---|
| `gd` | `<F12>` | Goto definition |
| — | `<F11>` | Go back (`<C-t>`, jumplist) |
| `gr` | `<F4>` ⚠️ | Goto references *(see [quirks](#quirks--things-worth-revisiting))* |
| `gI` | — | Goto implementation |
| `gD` | `<F10>` | Goto declaration |
| `<leader>D` | `<F9>` | Type definition |
| `<leader>ds` | — | Document symbols |
| `<leader>ws` | — | Workspace symbols |
| `<leader>rn` | `<F2>` | Rename symbol (LSP-wide rename, all references) |
| `<leader>ca` | `<F4>` ⚠️ | Code action *(see [quirks](#quirks--things-worth-revisiting))* |
| `K` | `<F1>` | Hover documentation |
| `<leader>th` | — | Toggle inlay hints (only if the server supports them) |

Goto-definition/references/implementation/etc. are routed through Telescope, so they open in a fuzzy-searchable picker rather than jumping directly when there are multiple results.

---

## Git (gitsigns + snacks)

`plugins/git.lua` (per-hunk, buffer-local) + `plugins/snacks.lua` (repo-level tools).

| Key | Mode | Action |
|---|---|---|
| `]c` | n | Next git hunk |
| `[c` | n | Previous git hunk |
| `<leader>hs` | n, v | Stage hunk |
| `<leader>hr` | n, v | Reset hunk |
| `<leader>hS` | n | Stage whole buffer |
| `<leader>hu` | n | Undo last stage |
| `<leader>hR` | n | Reset whole buffer |
| `<leader>hp` | n | Preview hunk |
| `<leader>hb` | n | Blame current line |
| `<leader>hd` | n | Diff against index |
| `<leader>hD` | n | Diff against last commit |
| `<leader>tb` | n | Toggle inline blame |
| `<leader>tD` | n | Toggle "show deleted" hunks |
| `<leader>gg` | n | Open LazyGit in a floating window |
| `<leader>gb` | n, v | Open current file/line/branch on GitHub in the browser |

> tmux also has its own LazyGit popup on `` ` `` + `g` (the `tmux-neolazygit` plugin) — same tool, useful when you're not inside Neovim.

---

## Diagnostics (trouble)

`plugins/trouble.lua`

| Key | Action |
|---|---|
| `xx` | Toggle diagnostics list (whole workspace) |
| `xX` | Toggle diagnostics list (current buffer only) |
| `xL` | Toggle location list |
| `xQ` | Toggle quickfix list |
| `<leader>cs` | Toggle symbols outline |
| `<leader>cl` | Toggle LSP definitions/references list |

---

## AI / Claude Code

`plugins/claudecode.lua` — requires the `claude` CLI on `$PATH`.

| Key | Mode | Action |
|---|---|---|
| `<leader>ac` | n | Toggle the Claude terminal |
| `<leader>af` | n | Focus the Claude terminal |
| `<leader>ar` | n | Resume last session (`--resume`) |
| `<leader>aC` | n | Continue session (`--continue`) |
| `<leader>am` | n | Select model |
| `<leader>ab` | n | Add current buffer to Claude's context |
| `<leader>as` | v | Send visual selection to Claude |
| `<leader>aa` | n | Accept a proposed diff |
| `<leader>ad` | n | Deny a proposed diff |

`:ClaudeCodeTreeAdd` (add a file from neo-tree to context) exists but is **not yet bound to a key** — neo-tree's own `a` is already "add file", so this needs a deliberate non-conflicting binding if you want it.

---

## Snacks utilities

`plugins/snacks.lua` — see also the Buffers and Git sections above for `<leader>bd`/`bo`/`ba` and `<leader>gg`/`gb`.

| Key | Mode | Action |
|---|---|---|
| `<leader>tt` | n | Toggle a floating terminal |
| `<leader>rf` | n | Rename the current **file** (LSP-aware, distinct from `<leader>rn` symbol rename) |
| `<leader>.` | n | Toggle a persistent scratch buffer |

Passive/visual modules (no keys to learn): `bigfile` and `quickfile` (perf safety nets), `indent` (indent guides), `words` (auto-highlights + lets you jump between references of the symbol under the cursor with `]]` / `[[`), `input` (nicer prompt UI for things like LSP rename), `notifier` (nicer `vim.notify` popups).

---

## Formatting / docstrings / auto-import

| Key | Mode | Plugin | Action |
|---|---|---|---|
| `<leader>f` | n, v | conform.nvim (`autoformat.lua`) | Format buffer/selection |
| `<leader>ng` | n | neogen (`cmp.lua`) | Generate a docstring for the item under the cursor |
| `<leader>i` | n | nvim-lspimport (`plugins/init.lua`) | Auto-import the symbol under the cursor |

Format-on-save is controlled by the `:FormatDisable` / `:FormatDisable!` (buffer-only) / `:FormatEnable` user commands (`opts.lua`), not a keymap.

---

## Completion (insert mode)

`plugins/cmp.lua` — only active while the completion popup is visible.

| Key | Action |
|---|---|
| `<C-n>` / `<C-p>` | Next / previous completion item |
| `<C-b>` / `<C-f>` | Scroll documentation window back / forward |
| `<C-y>` | Confirm completion |
| `<CR>` | Confirm completion |
| `<Tab>` | Confirm if menu open, else expand/jump snippet, else fall through |
| `<S-Tab>` | Jump to previous snippet placeholder |
| `<C-Space>` | Manually trigger completion |
| `<C-l>` | Jump forward through snippet expansion points |
| `<C-h>` | Jump backward through snippet expansion points |

`nvim-autopairs` runs automatically alongside this (auto-closes brackets/quotes) — no keys of its own.

---

## Editing (multi-cursor, surround, comment)

| Key | Mode | Plugin | Action |
|---|---|---|---|
| `<A-S-Up>` | n | vim-visual-multi (`plugins/init.lua`) | Add a cursor on the line above |
| `<A-S-Down>` | n | vim-visual-multi | Add a cursor on the line below |
| `gc` / `gcc` | n, v | Comment.nvim | Comment/uncomment selection or current line (plugin default, not explicitly set in this config) |
| `sa{motion}{char}` | n, v | mini.surround | Add surrounding, e.g. `saiw)` |
| `sd{char}` | n | mini.surround | Delete surrounding, e.g. `sd'` |
| `sr{char}{char}` | n | mini.surround | Replace surrounding, e.g. `sr)'` |
| `a{obj}` / `i{obj}` | operator-pending, v | mini.ai | Around/inside textobjects, e.g. `va)`, `ci'` |

vim-visual-multi ships with many more default mappings beyond the two overridden here (its most common one is `<C-n>` in normal mode to select the word under the cursor and add a cursor on each further match) — run `:help visual-multi` for the full list.

---

## Plugin manager

| Key | Action |
|---|---|
| `l` | Open the `:Lazy` plugin manager UI |

---

## Quirks & things worth revisiting

Things spotted while assembling this doc — flagging in case you want to change them:

- **`<F4>` is bound twice** in `lsp.lua`: once to "goto references" and once to "code action". The second `map()` call silently overwrites the first, so `<F4>` currently only ever does code action — `gr` is the only working way to get references. Probably worth moving one of the two to a free function key (`<F3>`, `<F5>`, `<F6>`... are all unused).
- **Three duplicate mnemonic pairs exist for muscle-memory speed**: `ff` = `<leader>sf` (find files), `fg` = `<leader>sg` (live grep), `fb` = `<leader><leader>` (buffers). Intentional-looking (fast unprefixed access vs. discoverable leader-prefixed access), but worth confirming you actually use both forms of each pair.
- **`mini.surround` claims the bare `s` key** (`sa`, `sd`, `sr`, `sf`, `sF`, `sh`, `sn`, `sl`, ...), which shadows Vim's native `s`/`S` (substitute character/line). `cl`/`cc` give you the same native behavior back if you ever reach for `s` out of habit and get surround's UI instead.
- **`ClaudeCodeTreeAdd` has no keymap** (see [AI / Claude Code](#ai--claude-code)) — add one if you want to add files to Claude's context straight from the neo-tree sidebar.
- **`which-key.nvim`** (`plugins/which-key.lua`) is active and will pop up automatically whenever you pause after `<leader>` or one of the bracket/prefix keys above — a live, in-editor version of this file. If a mapping here looks stale, `<leader>` + wait is the fastest way to check what's actually registered.

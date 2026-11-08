# glow-preview

Preview the current markdown file with
[glow](https://github.com/charmbracelet/glow), once in a Vim terminal split, or
live in a pane next to Vim that re-renders on every save.

**Vim or Neovim:** Vim only, tested on 9.1 and newer. It calls a Vim-only
function (`job_start()`), so it doesn't work on Neovim.

## Install

Needs `glow`. Live mode also needs [entr](https://github.com/eradman/entr), and
tmux or WezTerm; without them it falls back to the static preview.

```vim
Plug 'vimoured/glow-preview'
```

## Use

| Command | `<Plug>` mapping | What it does |
| --- | --- | --- |
| `:GlowPreview` | `<Plug>(glow-preview)` | Preview the current file. |
| `:GlowPreviewToggleLive` | `<Plug>(glow-preview-toggle-live)` | Switch between static and live preview. |

Bind the mappings yourself, for example in `~/.vim/ftplugin/markdown.vim`:

```vim
nmap <buffer> <localleader>p <Plug>(glow-preview)
nmap <buffer> <localleader>P <Plug>(glow-preview-toggle-live)
```

Set `g:glow_preview_live` to `1` to start in live mode.

## Tests

The specs in [vim-suite](https://github.com/vimoured/vim-suite) define what it
does: `test/glow-preview.vim` and `test/glow-preview-outside-tmux.vim`.

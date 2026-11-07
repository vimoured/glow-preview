# glow-preview

Preview the current markdown file with [glow](https://github.com/charmbracelet/glow).

- **Static** (default): glow renders the file once in a vertical `:terminal`
  split, and the cursor stays in the file. Running it again replaces the
  previous preview.
- **Live**: glow re-renders on every save in a pane next to Vim, through
  [entr](https://github.com/eradman/entr). Inside tmux this uses
  `tmux split-window`; in WezTerm, `wezterm cli split-pane`. Running it again
  replaces the previous pane (*not yet*: it opens another one each time).
  Without entr (which it warns about), or outside tmux and WezTerm, it falls
  back to the static preview.

| Command | `<Plug>` mapping | What it does |
| --- | --- | --- |
| `:GlowPreview` | `<Plug>(glow-preview)` | Preview the current file. Without glow, it says `glow-preview: glow not found on PATH`. |
| `:GlowPreviewToggleLive` | `<Plug>(glow-preview-toggle-live)` | Switch between static and live preview, saying which: `Glow preview: LIVE` or `STATIC`. |

*Not yet* marks a known bug: [vim-suite](https://github.com/vimoured/vim-suite)
asserts the behaviour described (its `test/known-failures.txt`), and the note
goes once it's fixed.

No keys are bound. For example, in `~/.vim/ftplugin/markdown.vim`:

```vim
nmap <buffer> <localleader>p <Plug>(glow-preview)
nmap <buffer> <localleader>P <Plug>(glow-preview-toggle-live)
```

## Options

| Variable | Default | |
| --- | --- | --- |
| `g:glow_preview_live` | `0` | Start in live mode. |

## Install

Requires `glow`; `entr` (and tmux or WezTerm) for live mode. No other plugins.

```vim
Plug 'vimoured/glow-preview'
```

## Tests

Tested by [vim-suite](https://github.com/vimoured/vim-suite), in
`test/glow-preview.vim` and `test/glow-preview-outside-tmux.vim`, with the
dotfiles that use it. Every pull request runs them; the tests that run glow,
entr or tmux are TODOs where those aren't installed, as on CI. The WezTerm live
pane is a TODO.

let s:is_wezterm = ($TERM_PROGRAM ==# 'WezTerm' || !empty($WEZTERM_PANE))
let s:is_tmux = !empty($TMUX)

function! s:WeztermBin() abort
  if executable('wezterm')
    return 'wezterm'
  elseif executable('wezterm.exe')
    return 'wezterm.exe'
  endif
  return ''
endfunction

function! glow_preview#toggle_live() abort
  let g:glow_preview_live = !g:glow_preview_live

  if g:glow_preview_live
    echo "Glow preview: LIVE"
  else
    echo "Glow preview: STATIC"
  endif
endfunction

function! s:CloseGlowBuffers() abort
  for b in getbufinfo()
    if b.name =~# '__glow_preview'
      silent execute 'bwipeout!' b.bufnr
    endif
  endfor
endfunction

function! s:GlowStaticPreview() abort
  call s:CloseGlowBuffers()

  execute 'vert term glow ' .. fnameescape(expand('%:p'))
  setlocal filetype=glow
  file __glow_preview

  wincmd p
endfunction

function! s:GlowLivePreviewWezterm() abort
  let l:filename = shellescape(expand('%:p'))
  " It isn't easy to switch back to the original pane back again in wezterm on
  " wsl
  let l:cmd = printf(
        \ '%s cli split-pane --right -- bash -c "echo %s | entr -c glow -t -l /_"',
        \ s:WeztermBin(),
        \ l:filename
        \ )

  call job_start(
        \ ['bash', '-c', l:cmd],
        \ {'in_io': 'null', 'out_io': 'null', 'err_io': 'null'}
        \ )
endfunction

function! s:GlowLivePreviewTmux() abort
  if exists('s:tmux_pane')
    call system('tmux kill-pane -t ' . s:tmux_pane)
  endif
  let l:cmd = 'echo ' . shellescape(expand('%:p')) . ' | entr -c glow -t -l /_'
  let s:tmux_pane = trim(system('tmux split-window -d -h -P -F "#{pane_id}" ' . shellescape(l:cmd)))
endfunction

function! glow_preview#preview() abort
  if !executable('glow')
    echohl ErrorMsg
    echom 'glow-preview: glow not found on PATH'
    echohl None
    return
  endif

  if g:glow_preview_live
    if !executable('entr')
      echohl WarningMsg
      echom 'Glow live preview requires entr (not found on PATH); falling back to static preview.'
      echohl None
    else
      if s:is_tmux
        call s:GlowLivePreviewTmux()
        return
      endif

      if s:is_wezterm && !empty(s:WeztermBin())
        call s:GlowLivePreviewWezterm()
        return
      endif
    endif
  endif

  call s:GlowStaticPreview()
endfunction

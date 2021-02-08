" =============================================================================
" URL: https://github.com/sainnhe/gruvbox-material
" Filename: autoload/ibm.vim
" Author: sainnhe
" Email: sainnhe@gmail.com
" License: MIT License
" =============================================================================

function! ibm#get_configuration() "{{{
  return {
        \ 'background': get(g:, 'ibm_background', 'medium'),
        \ 'palette': get(g:, 'ibm_palette', 'material'),
        \ 'transparent_background': get(g:, 'ibm_transparent_background', 0),
        \ 'disable_italic_comment': get(g:, 'ibm_disable_italic_comment', 0),
        \ 'enable_bold': get(g:, 'ibm_enable_bold', 0),
        \ 'enable_italic': get(g:, 'ibm_enable_italic', 0),
        \ 'cursor': get(g:, 'ibm_cursor', 'auto'),
        \ 'visual': get(g:, 'ibm_visual', 'grey background'),
        \ 'menu_selection_background': get(g:, 'ibm_menu_selection_background', 'grey'),
        \ 'sign_column_background': get(g:, 'ibm_sign_column_background', 'default'),
        \ 'current_word': get(g:, 'ibm_current_word', get(g:, 'ibm_transparent_background', 0) == 0 ? 'grey background' : 'bold'),
        \ 'statusline_style': get(g:, 'ibm_statusline_style', 'default'),
        \ 'lightline_disable_bold': get(g:, 'ibm_lightline_disable_bold', 0),
        \ 'diagnostic_text_highlight': get(g:, 'ibm_diagnostic_text_highlight', 0),
        \ 'diagnostic_line_highlight': get(g:, 'ibm_diagnostic_line_highlight', 0),
        \ 'better_performance': get(g:, 'ibm_better_performance', 0),
        \ }
endfunction "}}}

function! ibm#get_palette(background, palette) "{{{

  if type(a:palette) == 4
    return a:palette
  endif

  let palette1 = {
        \ 'bg0':              ['#1d2021',   '234'],
        \ 'bg1':              ['#282828',   '235'],
        \ 'bg2':              ['#282828',   '235'],
        \ 'bg3':              ['#3c3836',   '237'],
        \ 'bg4':              ['#3c3836',   '237'],
        \ 'bg5':              ['#504945',   '239'],
        \ 'bg_statusline1':   ['#282828',   '235'],
        \ 'bg_statusline2':   ['#32302f',   '235'],
        \ 'bg_statusline3':   ['#504945',   '239'],
        \ 'bg_diff_green':    ['#32361a',   '22'],
        \ 'bg_visual_green':  ['#333e34',   '22'],
        \ 'bg_diff_red':      ['#3c1f1e',   '52'],
        \ 'bg_visual_red':    ['#442e2d',   '52'],
        \ 'bg_diff_blue':     ['#0d3138',   '17'],
        \ 'bg_visual_blue':   ['#2e3b3b',   '17'],
        \ 'bg_visual_yellow': ['#473c29',   '94'],
        \ 'bg_current_word':  ['#32302f',   '236']
        \ }

  let palette2 = {
        \ 'fg0':              ['#d4be98',   '223'],
        \ 'fg1':              ['#ddc7a1',   '223'],
        \ 'red':              ['#ea6962',   '167'],
        \ 'orange':           ['#e78a4e',   '208'],
        \ 'yellow':           ['#d8a657',   '214'],
        \ 'green':            ['#a9b665',   '142'],
        \ 'aqua':             ['#89b482',   '108'],
        \ 'blue':             ['#7daea3',   '109'],
        \ 'purple':           ['#d3869b',   '175'],
        \ 'bg_red':           ['#ea6962',   '167'],
        \ 'bg_green':         ['#a9b665',   '142'],
        \ 'bg_yellow':        ['#d8a657',   '214']
        \ }

  let palette3 = {
        \ 'grey0':            ['#7c6f64',   '243'],
        \ 'grey1':            ['#928374',   '245'],
        \ 'grey2':            ['#a89984',   '246'],
        \ 'none':             ['NONE',      'NONE']
        \ } 

  return extend(extend(palette1, palette2), palette3)
endfunction "}}}

function! ibm#highlight(group, fg, bg, ...) "{{{
  execute 'highlight' a:group
        \ 'guifg=' . a:fg[0]
        \ 'guibg=' . a:bg[0]
        \ 'ctermfg=' . a:fg[1]
        \ 'ctermbg=' . a:bg[1]
        \ 'gui=' . (a:0 >= 1 ?
          \ (a:1 ==# 'undercurl' ?
            \ (executable('tmux') && $TMUX !=# '' ?
              \ 'underline' :
              \ 'undercurl') :
            \ a:1) :
          \ 'NONE')
        \ 'cterm=' . (a:0 >= 1 ?
          \ (a:1 ==# 'undercurl' ?
            \ 'underline' :
            \ a:1) :
          \ 'NONE')
        \ 'guisp=' . (a:0 >= 2 ?
          \ a:2[0] :
          \ 'NONE')
endfunction "}}}
function! ibm#ft_gen(path, last_modified, msg) "{{{
  " Generate the `after/ftplugin` directory.
  let full_content = join(readfile(a:path), "\n") " Get the content of `colors/gruvbox-material.vim`
  let ft_content = []
  let rootpath = ibm#ft_rootpath(a:path) " Get the path to place the `after/ftplugin` directory.
  call substitute(full_content, '" ft_begin.\{-}ft_end', '\=add(ft_content, submatch(0))', 'g') " Search for 'ft_begin.\{-}ft_end' (non-greedy) and put all the search results into a list.
  for content in ft_content
    let ft_list = []
    call substitute(matchstr(matchstr(content, 'ft_begin:.\{-}{{{'), ':.\{-}{{{'), '\(\w\|-\)\+', '\=add(ft_list, submatch(0))', 'g') " Get the file types. }}}}}}
    for ft in ft_list
      call ibm#ft_write(rootpath, ft, content) " Write the content.
    endfor
  endfor
  call ibm#ft_write(rootpath, 'text', "let g:ibm_last_modified = '" . a:last_modified . "'") " Write the last modified time to `after/ftplugin/text/ibm.vim`
  if a:msg ==# 'update'
    echohl WarningMsg | echom '[gruvbox-material] Updated ' . rootpath . '/after/ftplugin' | echohl None
  else
    echohl WarningMsg | echom '[gruvbox-material] Generated ' . rootpath . '/after/ftplugin' | echohl None
  endif
endfunction "}}}
function! ibm#ft_write(rootpath, ft, content) "{{{
  " Write the content.
  let ft_path = a:rootpath . '/after/ftplugin/' . a:ft . '/ibm.vim' " The path of a ftplugin file.
  " create a new file if it doesn't exist
  if !filereadable(ft_path)
    call mkdir(a:rootpath . '/after/ftplugin/' . a:ft, 'p')
    call writefile([
          \ "if !exists('g:colors_name') || g:colors_name !=# 'gruvbox-material'",
          \ '    finish',
          \ 'endif'
          \ ], ft_path, 'a') " Abort if the current color scheme is not gruvbox-material.
    call writefile([
          \ "if index(g:ibm_loaded_file_types, '" . a:ft . "') ==# -1",
          \ "    call add(g:ibm_loaded_file_types, '" . a:ft . "')",
          \ 'else',
          \ '    finish',
          \ 'endif'
          \ ], ft_path, 'a') " Abort if this file type has already been loaded.
  endif
  " If there is something like `call ibm#highlight()`, then add
  " code to initialize the palette and configuration.
  if matchstr(a:content, 'ibm#highlight') !=# ''
    call writefile([
          \ 'let s:configuration = ibm#get_configuration()',
          \ 'let s:palette = ibm#get_palette(s:configuration.background, s:configuration.palette)'
          \ ], ft_path, 'a')
  endif
  " Append the content.
  call writefile(split(a:content, "\n"), ft_path, 'a')
endfunction "}}}
function! ibm#ft_rootpath(path) "{{{
  " Get the directory where `after/ftplugin` is generated.
  if (matchstr(a:path, '^/usr/share') ==# '') || has('win32') " Return the plugin directory. The `after/ftplugin` directory should never be generated in `/usr/share`, even if you are a root user.
    return fnamemodify(a:path, ':p:h:h')
  else " Use vim home directory.
    if has('nvim')
      return stdpath('config')
    else
      if has('win32') || has ('win64')
        return $VIM . '/vimfiles'
      else
        return $HOME . '/.vim'
      endif
    endif
  endif
endfunction "}}}
function! ibm#ft_newest(path, last_modified) "{{{
  " Determine whether the current ftplugin files are up to date by comparing the last modified time in `colors/gruvbox-material.vim` and `after/ftplugin/text/ibm.vim`.
  let rootpath = ibm#ft_rootpath(a:path)
  execute 'source ' . rootpath . '/after/ftplugin/text/ibm.vim'
  return a:last_modified ==# g:ibm_last_modified ? 1 : 0
endfunction "}}}
function! ibm#ft_clean(path, msg) "{{{
  " Clean the `after/ftplugin` directory.
  let rootpath = ibm#ft_rootpath(a:path)
  " Remove `after/ftplugin/**/ibm.vim`.
  let file_list = split(globpath(rootpath, 'after/ftplugin/**/ibm.vim'), "\n")
  for file in file_list
    call delete(file)
  endfor
  " Remove empty directories.
  let dir_list = split(globpath(rootpath, 'after/ftplugin/*'), "\n")
  for dir in dir_list
    if globpath(dir, '*') ==# ''
      call delete(dir, 'd')
    endif
  endfor
  if globpath(rootpath . '/after/ftplugin', '*') ==# ''
    call delete(rootpath . '/after/ftplugin', 'd')
  endif
  if globpath(rootpath . '/after', '*') ==# ''
    call delete(rootpath . '/after', 'd')
  endif
  if a:msg
    echohl WarningMsg | echom '[gruvbox-material] Cleaned ' . rootpath . '/after/ftplugin' | echohl None
  endif
endfunction "}}}
function! ibm#ft_exists(path) "{{{
  return filereadable(ibm#ft_rootpath(a:path) . '/after/ftplugin/text/ibm.vim')
endfunction "}}}

" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:

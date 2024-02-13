
" INSTALLATION INSTRUCTIONS:
" 1) install neovim (sudo apt-get install neovim) and place this file in .config/nvim/init.vim
" 2) Then install vim-plug by running: 
    " sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
    "       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
" 3) Then install plug-ins using :PlugInstall

call plug#begin()
    " Plug 'tomasiser/vim-code-dark' " Color Scheme VS-Code Theme
    Plug 'catppuccin/nvim', {'as': 'catppuccin'}
    Plug 'preservim/nerdcommenter' " Code Comment plug-in
    Plug 'mhinz/vim-startify' " Fancy start screen for when you run nvim without a file to open.
    Plug 'itchyny/lightline.vim' " Nicer status bar for editor.
    Plug 'ap/vim-css-color' " Automatically shows hex-code colors as background color in-line.

    Plug 'scrooloose/nerdtree' " Nerd Tree plug-ins 
    Plug 'ryanoasis/vim-devicons' " Requires terminal to use a Nerd Font (Caskaydia Cove Nerd mono for windows terminal default) for icons.
    Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
    Plug 'Xuyuanp/nerdtree-git-plugin' 

    " https://github.com/hrsh7th/nvim-cmp
    Plug 'neovim/nvim-lspconfig'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-cmdline'
    Plug 'hrsh7th/nvim-cmp'

    " https://github.com/hrsh7th/vim-vsnip
    Plug 'hrsh7th/cmp-vsnip'
    Plug 'hrsh7th/vim-vsnip'
    Plug 'rafamadriz/friendly-snippets'
    
    " Lets you use tab to override completion macros.
    Plug 'ervandew/supertab' 
call plug#end()
filetype plugin indent on

"
"
" Regular Vim Configuration Settings.
"
"
set nocompatible
set showmatch
set ignorecase
set hlsearch
set incsearch
set tabstop=4
set softtabstop=4
set expandtab " Replaces tab characters with softtabstop characters of whitespace.
set shiftwidth=4
set autoindent
set relativenumber
set number
set listchars=tab:▸\ ,eol:¬ " Visualize tabs and newlines when asked with shortcut defined below.
set showcmd
set wildmode=longest,list
set nowrap
set mouse=a
set guicursor=a:blinkon100
set clipboard=unnamedplus
set ttyfast
set spell
set noshowmode " hides --mode-- from editor since using light line plug-in.
syntax enable " turn on syntax highlighting
syntax on
set splitright " open new split panes to right and below
set splitbelow
let mapleader = ' ' " Set the leader key to space.

let g:catppuccin_flavour = "mocha"

lua << EOF
require("catppuccin").setup()
EOF

colorscheme catppuccin

if (has('termguicolors'))
    set termguicolors
endif

" Set background color to be transparent to match terminal background.
highlight Normal ctermbg=NONE guibg=NONE
highlight EndOfBuffer ctermfg=DarkGrey ctermbg=NONE guifg=#666666 guibg=NONE
highlight NonText ctermbg=NONE
highlight LineNr ctermfg=DarkGrey ctermbg=NONE guifg=#666666 guibg=NONE 
highlight StatusLine ctermfg=White ctermbg=NONE guifg=#FFFFFF guibg=NONE
highlight SpellBad cterm=underline,italic ctermfg=Red ctermbg=NONE gui=underline,italic guifg=Red guibg=NONE 

" Colors current line differently from relative lines.
highlight clear CursorLine
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=#666666 guibg=NONE
highlight CursorLineNr term=bold cterm=NONE ctermfg=yellow ctermbg=NONE gui=NONE guifg=#e2e822 guibg=NONE

" If I type :wq in insert mode prepares to exit editor.
inoremap :wq <C-o>:wq 

" Control-z in insert mode escapes and closes editor.
inoremap <C-z> <C-o><ESC><C-z>

" Allows capital Q and W to write or quit editor
:command! Q q
:command! Qa qa!
:command! W w
:command! Wq wq

" Toggle viewing tabs and EOL use leader key + l 
map <leader>l :set list!<CR> 

"
"
" Comment lines using nerdcommenter and control-/ in normal, visual, and insert modes.
"
"
nnoremap <C-_> :call nerdcommenter#Comment(0,"toggle")<CR>
vnoremap <C-_> :call nerdcommenter#Comment(0,"toggle")<CR>
inoremap <C-_> <C-o>:call nerdcommenter#Comment(0,"toggle")<CR>
nnoremap <leader>c :call nerdcommenter#Comment(0, "toggle")<CR>

"
"
" Configure LightLine bar
"
"
let g:lightline = {
      \ 'colorscheme': 'Tomorrow_Night_Bright',
      \ }
" Makes the center of the lightline transparent
let s:palette = g:lightline#colorscheme#{g:lightline.colorscheme}#palette
let s:palette.normal.middle = [ [ 'NONE', 'NONE', 'NONE', 'NONE' ] ]
let s:palette.inactive.middle = s:palette.normal.middle
let s:palette.tabline.middle = s:palette.normal.middle

"
"
" NERDTree Configuration
"
"
let g:NERDSpaceDelims = 1 " Adds a single space following comment symbol.
let g:NERDTreeShowHidden = 1 
let g:NERDTreeMinimalUI = 1 " hide helper
let g:NERDTreeIgnore = ['^node_modules$'] " ignore node_modules to increase load speed 
let g:NERDTreeStatusline = '' " set to empty to use lightline

" Toggle showing nerdtree with control-b
noremap <silent> <C-b> :NERDTreeToggle<CR>
nnoremap <leader>n :NERDTreeFind<bar> :vertical resize 40<CR>

" Close window if NERDTree is the last one
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Always hide brackets in nerdtree since using a nerd font.
augroup nerdtreeconcealbrackets
      autocmd!
      autocmd FileType nerdtree syntax match hideBracketsInNerdTree "\]" contained conceal containedin=ALL
      autocmd FileType nerdtree syntax match hideBracketsInNerdTree "\[" contained conceal containedin=ALL
      autocmd FileType nerdtree setlocal conceallevel=3
      autocmd FileType nerdtree setlocal concealcursor=nvic
augroup END

" NERDTree Syntax Highlight
" Enables folder icon highlighting using exact match
let g:NERDTreeHighlightFolders = 1 
" Highlights the folder name
let g:NERDTreeHighlightFoldersFullName = 1 
" Color customization
let s:brown = '905532'
let s:aqua =  '3AFFDB'
let s:blue = '689FB6'
let s:darkBlue = '44788E'
let s:purple = '834F79'
let s:lightPurple = '834F79'
let s:red = 'AE403F'
let s:beige = 'F5C06F'
let s:yellow = 'F09F17'
let s:orange = 'D4843E'
let s:darkOrange = 'F16529'
let s:pink = 'CB6F6F'
let s:salmon = 'EE6E73'
let s:green = '8FAA54'
let s:lightGreen = '31B53E'
let s:white = 'FFFFFF'
let s:rspec_red = 'FE405F'
let s:git_orange = 'F54D27'
" Sets the color of css files to blue
let g:NERDTreeExtensionHighlightColor = {} " This line is needed to avoid error
let g:NERDTreeExtensionHighlightColor['css'] = s:blue
" Sets the color for .gitignore files
let g:NERDTreeExactMatchHighlightColor = {} " This line is needed to avoid error
let g:NERDTreeExactMatchHighlightColor['.gitignore'] = s:git_orange
" Sets the color for files ending with _spec.rb
let g:NERDTreePatternMatchHighlightColor = {} " This line is needed to avoid error
let g:NERDTreePatternMatchHighlightColor['.*_spec\.rb$'] = s:rspec_red
" Sets the color for folders that did not match any rule
let g:WebDevIconsDefaultFolderSymbolColor = s:beige
" Sets the color for files that did not match any rule
let g:WebDevIconsDefaultFileSymbolColor = s:blue

let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1

" NERDTree Git Plug-in special characters
let g:NERDTreeGitStatusIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }

lua <<EOF
  -- Set up nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- specify vsnip snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  -- require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
  --  capabilities = capabilities
  -- }
EOF

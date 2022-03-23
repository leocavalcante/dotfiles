syntax on

set formatoptions-=cro
set splitbelow splitright
set undofile
set ignorecase
set smartcase
set wrap
set textwidth=79
set formatoptions=qrn1
set incsearch
set number
set relativenumber
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

nnoremap <leader>ff <cmd>Telescope find_files hidden=true<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

let g:blamer_enabled = 1
let NERDTreeShowHidden = 1

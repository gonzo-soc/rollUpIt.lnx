### Vim
-------

1. #### Common Settings

	1.	To display line numbers:
	
			:set number

	2. To enable line numbers on startup:

			:set number

	3. To change to a current directory through <leader> + cd:
			
			nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>

	4. Syntax highlighting:
				
			syntax on 

	5. Full path in status bar:
				
			set statusline+=%F

	6. Apply changes without restarting

			:so ~/.vimrc

	7. The present working directory can be displayed in Vim with:

			:pwd

	8. To change to the directory of the currently open file (this sets the current directory for all windows in Vim):
			
			:cd %:p:h

	9. You can also change the directory only for the current window (each window has a local current directory that can be different from Vim's global current directory):
			
			:lcd %:p:h

		> [!NOTE] In these commands, % gives the name of the current file, %:p 
		> gives its full path, and %:p:h gives its directory (the "head" of the full path).
 
2. #### Indenting
 	1. Turn on the plugin 
 		
 			filetype plugin indent on		

 	2. Tab = 4
 			
			set expandtab

 	3. When indenting with '>', use 4 spaces width

 			set shifwwidth=4

 	4. On pressing tab, insert 4 spaces	
 			
 			set epandtab
 
3. #### How to work with windows

	1. To create Hor Windows: *Ctrl+W, S (upper case)* 
	2. To create Vert Windows: *Ctrl+W, v*
	3. To close one but keeps the buffer: *Ctrl+W, c*
	4. To close all but keeps the active win only: *Ctrl+W, o*
	5. To list all win 
	
			:ls

	6. To switch to 5th buffer

			:5b

	7. To resize the height of the current window by a single row: *Ctrl-w +* and *Ctrl-w -*
	
	8. For a vsplit window: *Ctrl-w >* and *Ctrl-w <*
	9. Increases the window size by 10 lines: *Ctrl-w 10 +*
	10. To resize all windows to equal dimensions based on their splits, you can use *Ctrl-w =.*
	11. To increase a window to its maximum height: *Ctrl-w _.*
	12. To increase a window to its maximum width: *Ctrl-w |.*
	13. *Control+W* followed by *W* to toggle between open windows and,
	14. *Control+W* followed by *H/J/K/L* to move to the left/bottom/top/right window accordingly.

4. #### [How to use registry](https://stackoverflow.com/questions/1497958/how-do-i-use-vim-registers)?

	1. Copy a line in 'k'-registry:
			
			"kyy
			"Kpp	

5. #### [Basic setup](https://statico.github.io/vim.html)
	1. Install *vim-puthogen*: *https://github.com/tpope/vim-pathogen*, - lets keep all plugin in a standalone dir;
	2. Change key map for buffers:
			
			nmap <C-e> :e#<CR>
			nmap <C-n> :bnext<CR>
			nmap <C-p> :bprev<CR>

	3. To list buffer:
	
			:buffers

	##### or 

			noremap <C-l> :buffers<CR>

	4. To map the selection buffer command (:3b) to key <digit> + Shift-l: we can use v:count, where <C-u> removes auto added range:
			
			nnoremap <leader>b :<C-u>execute 'b' v:count<cr>

	5. To install *vim.plugin* run:
	
			curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    ##### And add the following line to .vimrc:

    		call plug#begin('~/.vim/plugged')
    		...
    		call plug#end()

    6. Install fzf:

	    	call plug#begin('~/.vim/bundle')
	    	Plug '~/.fzf'
			Plug 'junegunn/fzf.vim'
			call plug#end()   

	7. Setup Statusline:

			" statusline 
			" format markers:        
			"   %< truncation point  
			"   %n buffer number     
			"   %f relative path to file    
			"   %m modified flag [+] (modified), [-] (unmodifiable) or nothing      
			"   %r readonly flag [RO]
			"   %y filetype [ruby]   
			"   %= split point for left and right justification 
			"   %-35. width specification   
			"   %l current line number      
			"   %L number of lines in buffer
			"   %c current column number    
			"   %V current virtual column number (-n), if different from %c         
			"   %P percentage through buffer
			"   %) end of width specification         
			"   %L Common number of rows    
			" set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P  
			" Good example of status line https://nkantar.com/blog/my-vim-statusline
			" display statusline always     
			set laststatus=2         
			set statusline=
			set statusline=%<%F      
			set statusline+=%30.(%y\[m:%{mode()}\]\[bf:%{winnr()}\]%m%r%) 
			" strftime - display time string, see     
			" https://vimhelp.org/eval.txt.html#strftime%28%29  
			set statusline+=%=%-14.(%{strftime('%Y\ %b\ %d\ %X')}\ %l,%c%V%)\ \[%P/%L\]

			" Works in vim > 7 ver ONLY.    
			let s:timer_rt=timer_start(1000, {-> execute(':let &stl=&stl')}, {'repeat': -1})  

6. #### How to install vim 8 in CentOS 7 (By default, it is installed as 7th version)
	1. Prepare:
		
			yum install ncurses-devel

	2. Run the following

			#!/bin/bash                    
			mkdir mk_vim                   
			cd mk_vim                      

			git clone https://github.com/vim/vim.git                                                                  
			cd vim                         
			make distclean  # if you build Vim before 
			make -j8                       

			sudo make install              

	3. After installation the new vim will be located in /usr/local/bin and it needs to clear bash hash: to rewrite the location

			hash -r vim 

	4. Rename old vim binary files:

			sudo find /usr/bin -regex .*/.*vim.* -exec mv '{}' '{}'_7v \;

7. #### How to set a current file executable?
	1. Write the following function:

			function! SetExecutableBit()
				let fname = expand("%:p")
				checktime
				execute "au FileChangedShell " . fname . " :echo"
				silent !chmod a+x %
				checktime
				execute "au! FileChangedShell " . fname
			endfunction
			command! Xbit call SetExecutableBit()
			
	> [!Note] We call checktime function to check if any changes were applied outside to the buffer [see more details] (https://vimhelp.org/editing.txt.html). To suppress vim to trigger any action on FileChangedShell event we redefine the event with use of :
			
			execute "au FileChangedShell " . fname . " :echo" 

	>and revert the changes back:

			execute "au! FileChangedShell " . fname . " :echo" 		
							
8. #### How to work with colors in different modes?

	1. Command *highlight*:
	
			highlight Comment cterm=bold ctermbg=Black ctermfg=Gray guifg=... guibg=...

	where we have to set highlight groups:

		Visual

		Comment

		Constant

		Normal

		NonText

		Special

		Cursor

	*cterm*:

		bold
		underline
		undercurl	not always available
		reverse
		inverse		same as reverse
		italic
		standout
		NONE	

	2. [Map xterm256 to vim](https://vim.fandom.com/wiki/Xterm256_color_names_for_console_Vim).

	3. [xterm256 colors](https://jonasjacek.github.io/colors/)

	> [!Links]
	> 1. https://alvinalexander.com/linux/vi-vim-editor-color-scheme-syntax

9. ##### Autoformat

	1. Add *python* support to the vim:

	+ Download vim src: https://github.com/vim/vim.git 

	+ Compile *vim* with the python support: run `configure` as the following:

			./configure --with-features=huge \
			    --enable-multibyte \
			    --enable-rubyinterp=yes \
			    --enable-pythoninterp=yes \
			    --with-python-command=python2.7 \
			    --with-python-config-dir=/usr/lib64/python2.7/config \
			    --enable-python3interp=yes \
			    --with-python3-config-dir=/usr/lib64/python3.6/config-3.6m-x86_64-linux-gnu \
			    --with-python3-command=python3.6 \
			    --enable-cscope \
			    --enable-fail-if-missing \ 

	+ Install an appropriate format util: https://github.com/Chiel92/vim-autoformat

	2. Use the plugin: `Plugin 'Chiel92/vim-autoformat'` from [here](https://github.com/Chiel92/vim-autoformat): 

	+ Add the following to *.vimrc*:

			Plugin 'Chiel92/vim-autoformat'
			...
			let g:autoformat_autoindent = 0
			let g:autoformat_retab = 0
			let g:autoformat_remove_trailing_spaces = 0
			noremap <Esc>, :Autoformat<CR>
			" Use of the tuned .sh format util (Google Style: https://google.github.io/styleguide/shell.xml)
			let g:formatdef_my_custom_sh = '"shfmt -i 2 -ci"'
			let g:formatters_sh = ['my_custom_sh']
			au BufReadPost,BufNewFile,BufWrite *.sh :Autoformat




if !has("python3")
    echo "vim has to be compiled with +python to run this"
    finish
endif

python3 << en

import vim, dominate
from dominate import tags as tags

def getWordUnderCursor():
    return vim.eval("expand('<cWORD>')").split(',')

def getPosCol(): 
    cw = vim.current.window
    return cw.cursor

def inputforms():
    words = vim.eval("expand('<cWORD>')")
    words = words.split(',')
    form = tags.form()
    b = vim.current.buffer
    cw = vim.current.window
    pos = cw.cursor[0]
    for word in words:
        label = tags.label(fr=word)
        input_ = tags.input_(type='text', name=word, id=word)
        b.append(label.render(), pos)
        pos += 1
        b.append(input_.render(), pos)
        pos += 1

def cssRangeSelector():
    inp = vim.eval("expand('<cWORD>')")
    inp = inp.split('*')
    num = int(inp[-1])
    b = vim.current.buffer
    cw = vim.current.window
    pos = cw.cursor[0]
    for i in range(1, num+1):
        string = inp[0].replace('$',str(i)) + " {"
        b.append(string, pos)
        pos += 1
        b.append("}", pos)
        pos += 1
        b.append(" ", pos)
        pos += 1

def rmNum():
    cw = vim.current.window
    pos = cw.cursor[0]
    vim.command(":" + str(pos) + "s/\d//")
    vim.command(":star") #get in insert mode via command
    vim.command(":nohlsearch")

def markCommaSeperated():
    pos = getPosCol()
    cw = vim.current.window

    ####get outter Pairs of line pos[0]
    cw.cursor = (pos[0], 0) #start of line at line pos[0]
    left_pos = vim.eval("searchpos('(','cn'," + str(pos[0]) + ")")
    cw.cursor = (pos[0], 1000)  #end of line at line pos[0]
    right_pos = vim.eval("searchpairpos('(', '', ')', 'cn')")
    cw.cursor = (pos)  #go back to original position

    #####get commas
    b = vim.current.buffer
    commas = b[pos[0]-1]
    comma_barket_pos = [pos + 1 for pos, char in enumerate(commas) if char == ',']

    ####insert barket position to commas positions list
    comma_barket_pos.insert(0, int(left_pos[1]))
    comma_barket_pos.append(int(right_pos[1]))


    index = [index for index, i in enumerate(comma_barket_pos) if pos[1] <= i][0]
    cw.cursor = (pos[0], comma_barket_pos[index-1])
    print(index)
    vim.command('normal v')
    cw.cursor = (pos[0], comma_barket_pos[index]-2)
    #    print(comma_barket_pos)


    #    print(right_pos)
    #jk    ss = vim.command(":echom search('(','W'," + str(pos[0]) + ")")
    #jk    print(ss)

en

" nnoremap <silent> ,t :python3 inputforms()<CR>
inoremap <silent> ,t <Esc>:python3 inputforms()<CR>
" nnoremap <silent> ,f :python3 cssRangeSelector()<CR>
inoremap <silent> ,f <Esc>:python3 cssRangeSelector()<CR>
nnoremap <silent> dn :python3 rmNum()<CR>
nnoremap <silent> db :python3 markCommaSeperated()<CR>



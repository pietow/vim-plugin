" lookup the country for an IP address under the current cursor

" Make sure Python is ready
if !has("python3")
    echo "vim has to be compiled with +python3 to run this"
    finish
endif

python3 << en

import vim, urllib.request

def getCountryFromIP( ip ):
    # use the minimal http://www.hostip.info/use.html API
    return urllib.request.urlopen('https://api.ipfind.com?ip='+ip+'&auth=a5e7f4d7-b312-4804-aa7d-c5628ca4622e').read()

def getWordUnderCursor():
    return vim.eval("expand('<cWORD>')")

def lookupIPUnderCursor():
    ip = getWordUnderCursor()
    print("Looking up " + ip + "...")
    country = getCountryFromIP( ip )
    vim.command( "redraw" ) # discard previous messages
    print(country)

en

nmap <silent> ,IP :python3 lookupIPUnderCursor()<CR>

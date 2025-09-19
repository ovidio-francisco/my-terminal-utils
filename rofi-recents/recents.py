#!/usr/bin/env python3

import os
import subprocess
from rofi import Rofi
from urllib.parse import unquote
import xml.etree.ElementTree as et

def main():
    root = et.parse(os.getenv('HOME')+'/.local/share/recently-used.xbel').getroot()

    data = []

    for b in root.findall('bookmark'):
        h = b.get('href')
        a = b.get('added')
        m = b.get('modified')
        v = b.get('visited')

        date = max(a,m,v) 
        data.append([date, h]) 

    data.sort(reverse=True)


    r = Rofi()
    index, key = r.select('Select a file to open', [os.path.basename(unquote(i[1])) for i in data])

    if (index > -1):
        thefile = data[index][1] 
        subprocess.call(['xdg-open', thefile])
        

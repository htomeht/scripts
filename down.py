import os
import sys as sy
import getopt

links = [
'http://pic.freeporn.hu/danielle_black_and_white/60.jpg'    
    ]
parted = [s.split('/') for s in links]

dir = iter([x[-2] for x in parted])
cmd = 'wget'

ext = 'jpg'


max = iter([int(x[-1].split('.')[0]) + 1 for x in parted]) 
rng = iter([range(1, x) for x in max])

sys = os.system

use_link = iter([x[:-6] for x in links])

def run(dir,cmd,link,ext,rng):
    """Function to download one set"""
    
    sys('mkdir %s' % dir)

    for x in rng:
      if x in [1,2,3,4,5,6,7,8,9]:
        sys('cd %s && %s %s0%d.%s' % (dir,cmd,link,x,ext))
      else :
        sys('cd %s && %s %s%d.%s' % (dir,cmd,link,x,ext))

try: 
    while 1:
        run(dir.next(),cmd,use_link.next(),ext,rng.next())
except StopIteration:
    print "All Done."

#!/usr/bin/env python

import os

targets = []

date = '20150514'

front_page = 'http://hzdaily.hangzhou.com.cn/dskb/page/3/2015-05/14/01/%s01_pdf.pdf' % date
other_page_template = 'http://hzdaily.hangzhou.com.cn/dskb/page/3/2015-05/14/%(page)s/%(date)s%(page)s_pdf.pdf'

a_pages = range(2, 33)
b_pages = range(1, 17)
j_pages = range(1, 17)
n_pages = range(1, 17)

os.system('wget %s' % front_page)

for page_a in a_pages:
    os.system('wget %s' % other_page_template % {'page': 'A%02d' % page_a, 'date': date })

for page_a in b_pages:
    os.system('wget %s' % other_page_template % {'page': 'B%02d' % page_a, 'date': date })

#for page_a in j_pages:
#    os.system('wget %s' % other_page_template % {'page': 'J%02d' % page_a, 'date': date })

#for page_a in n_pages:
#    os.system('wget %s' % other_page_template % {'page': 'N%02d' % page_a, 'date': date })

pdf_files = ['%s01_pdf.pdf' % date]

for page_a in a_pages:
    pdf_files.append('%sA%02d_pdf.pdf' % (date,page_a))

for page_a in b_pages:
    pdf_files.append('%sB%02d_pdf.pdf' % (date,page_a))

#for page_a in j_pages:
#    pdf_files.append('%sJ%02d_pdf.pdf' % (date,page_a))

#for page_a in n_pages:
#    pdf_files.append('%sN%02d_pdf.pdf' % (date,page_a))


print(pdf_files)
os.system('pdftk %s cat output issue-%s.pdf' % (' '.join(pdf_files), date))

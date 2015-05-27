#!/usr/bin/env python

import os

targets = []

day = '27'
date = '201505%s' % day

front_page_template = 'http://hzdaily.hangzhou.com.cn/hzrb/page/1/2015-05/%s/01/2015052701_pdf.pdf' % day
page_template = 'http://hzdaily.hangzhou.com.cn/hzrb/page/1/2015-05/%s' %day + '/%(page)s/%(date)s%(page)s_pdf.pdf'

a_pages = range(2, 17)
b_pages = range(1, 9)

os.system('wget %s' % front_page_template)

pdf_files = ['201505%s01_pdf.pdf' % day]

for page in a_pages:
    return_code = os.system('wget %s' % page_template % {'page': 'A%02d' % page, 'date': date })
    if return_code == 0:
        pdf_files.append('%sA%02d_pdf.pdf' % (date,page))

for page in b_pages:
    return_code = os.system('wget %s' % page_template % {'page': 'B%02d' % page, 'date': date })
    if return_code == 0:
        pdf_files.append('%sB%02d_pdf.pdf' % (date,page))

print(pdf_files)
os.system('pdftk %s cat output hzrb_issue_%s.pdf' % (' '.join(pdf_files), date))

for pdf_file in pdf_files:
    os.system('rm %s' % pdf_file)

# 爬取观察者网的新闻

import time
import os
import bs4
import requests
from bs4 import BeautifulSoup


def getHTMLText(url): # 爬取网页内容的函数
    try:
        kv = {'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36'}
        r = requests.get(url, headers = kv, timeout = 30)
        r.raise_for_status()
        r.encoding = r.apparent_encoding
        return(r.text)
    except:
        return 'Response Status Wrong'


def parseHtml(html_text, file_path): # 解析网页并写文件函数
    soup = BeautifulSoup(html_text, 'html.parser')

    # 准备一些空列表
    l_title = []
    l_link = []
    l_author = []
    l_identity = []
    l_abstract = []
    l_attention = []
    l_comment = []
    l_time = []

    # 解析信息放入空列表中
    for title in soup.find_all('h4', 'module-title'):
        l_title.append(title.string)
        l_link.append('https://www.guancha.cn' + title.a.attrs['href'])
    for author in soup.find_all('div', 'author-intro fix'):
        l_author.append(author.find('p').find('a').string)
        l_identity.append(author.find('span').string.strip())
    for abstract in soup.find_all('p', 'module-artile'):
        l_abstract.append(abstract.string.strip())
    for interact in soup.find_all('div', 'module-interact'):
        l_attention.append(interact.find('a', 'interact-attention').string)
        l_comment.append(interact.find('a', 'interact-comment').string)
        l_time.append(interact.span.string[:10])

    for i in range(len(l_title)):
        article = '{},{},{},{},{},{},{},{}\n'.format(l_title[i], l_abstract[i], l_author[i], l_identity[i], l_attention[i], l_comment[i], l_time[i], l_link[i])
        with open(file_path, 'a+', encoding='utf-8') as f:
            f.write(article)
            f.close()
        print(article)


def spider_news(page, file_path):
    url = 'https://www.guancha.cn/mainnews-sp/list_{}.shtml'.format(str(page + 1))
    html_text = getHTMLText(url)
    parseHtml(html_text, file_path)


if __name__ == '__main__':
    # 设置全局变量
    file_path = './guanchazhe.csv'
    pages = 3 # 爬取页数

    if os.path.exists(file_path):
        os.remove(file_path)
    with open(file_path, 'a+', encoding='utf-8') as f:
        f.write('题目,摘要,作者,职务,点击数,评论数,发布时间,链接\n')
        f.close()

    for i in range(pages):
        spider_news(i, file_path)
        time.sleep(0.5) # 爬虫间隔，防止IP被封


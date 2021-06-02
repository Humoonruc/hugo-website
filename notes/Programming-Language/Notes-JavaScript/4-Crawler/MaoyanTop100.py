# 爬取猫眼电影前100名的信息

from multiprocessing import Pool
import requests
from bs4 import BeautifulSoup


def getHTMLText(url): # 爬取网页内容的函数
    try:
        kv = {'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36'}
        r = requests.get(url, headers = kv, timeout = 30)
        r.raise_for_status()
        r.encoding = r.apparent_encoding
        return r.text
    except:
        return 'Response Status Wrong'

def parseHtml(html_text): # 解析网页并写文件函数
    soup = BeautifulSoup(html_text, 'html.parser')
    for dd in soup.find_all('dd'):
        rank = dd.find("i").string
        name = dd.find('p', 'name').string.strip()
        stars = dd.find('p', 'star').string.strip().replace(',', ';')[3:]
        time_country = dd.find('p', 'releasetime').string[5:]
        time = time_country.split(sep='(')[0]
        score = dd.find('i', 'integer').string + dd.find('i', 'fraction').string
        film = '{},{},{},{},{}\n'.format(rank, name, stars, time, score)
        print(film)
        with open('MaoyanTop100.csv', 'a', encoding='utf-8') as f:
            f.write(film)
            f.close()

def main(offset): # 开启循环
    url = 'http://maoyan.com/board/4?offset=' + str(offset)
    html_text = getHTMLText(url)
    parseHtml(html_text)


if __name__ == '__main__':
    with open('MaoyanTop100.csv', 'a', encoding='utf-8') as f:
        title = '{},{},{},{},{}\n'.format('排名', '名称', '主演', '上映时间','评分')
        f.write(title)
        f.close()
    # 多进程抓取
    pool = Pool() # 进程池
    pool.map(main, [i*10 for i in range(10)]) # map(函数名，参数)
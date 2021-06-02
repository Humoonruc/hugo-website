// 抓取天涯论坛帖子信息

const superagent = require('superagent')
const cheerio = require('cheerio')
const fs = require('fs')

const mainUrl = 'http://bbs.tianya.cn'  //天涯论坛主域名
let url = '/list-45-1.shtml'    //重庆区域域名

let index = 1   //记录页码数
//发送请求获取页面资源方法
let getData = (url) => {
  // 使用superagent请求页面数据
  superagent.get(mainUrl + url)
    .end(function (err, res) {
      // 抛错拦截
      if (err) {
        return
        throw Error(err)
      }
      // 请求数据后使用cheerio解析数据
      let $ = cheerio.load(res.text)
      let data = []   //存储抓去到的数据
      $('.mt5 table tbody tr').each((index, item) => {
        let _this = $(item)
        //根据页面判断是否是文章
        if ($(_this.children()[0]).hasClass('td-title')) {
          //对数据进行存储
          let obj
          let title = $(_this.find('.td-title')).find('span').next().text()
          // let text = $(_this.find('a')[0]).text()  //另一种选择器
          let type = $(_this.find('.td-title')).find('.face').attr('title')
          let goto = $(_this.find('.td-title')).find('span').next().attr('href')
          let author = $(_this.children()[1]).text()
          let point = $(_this.children()[2]).text()
          let time = $(_this.children()[3]).text()
          obj = {
            title: title,
            type: type,
            url: mainUrl + goto,
            author: author,
            point: point,
            time: time
          }
          if (obj.title != "") {
            //判断如果有内容，则推送到data中
            data.push(obj)
          }
        }
      })

      if (data.length > 0) {  //判断data中是否有内容
        //使用fs模块对data中的数据进行储存，也可以使用数据库进行操作
        fs.writeFile(__dirname + '/data/articleLists' + index + '.json', JSON.stringify({
          status: 0,
          data: data
        }), function (err) {
          if (err) {
            console.log(err)
          } else {
            console.log("写入文章列表完成, 当前页码：", index)
            index++
          }
        })
      }

      //单次读取后，找到下一页的链接，继续抓取下一页的数据
      // let nextPage = $('.mt5').next().find('.short-pages-2 .links')
      // nextPage.children().each((index, item) => {
      //   if ($(item).text() === '下一页') {
      //     let url = $(item).attr("href")
      //     getData(url)
      //   }
      // })
    })
}

//初次执行数据抓取
getData(url)
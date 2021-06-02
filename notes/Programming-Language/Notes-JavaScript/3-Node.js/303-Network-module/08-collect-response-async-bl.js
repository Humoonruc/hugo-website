'use strict'
//08-collect-response-async-bl.js

const https = require('https')
const bl = require('bl')
// Node会自动查找是否有这个名字的核心模块
// 如果没有，再查找在 ./node_modules/ 目录下是否有这个模块

const URL = "https://www.runoob.com/nodejs/nodejs-tutorial.html";

https
  .get(URL, response => {
    response.pipe(bl((err, data) => {
      if (err) return console.error(err)

      // 经过bl模块的处理，data是服务器完整返回的Stream对象
      // 已经将所有返回块加总
      data = data.toString()
      console.log(data.length)
      console.log(data)
    }))
  })
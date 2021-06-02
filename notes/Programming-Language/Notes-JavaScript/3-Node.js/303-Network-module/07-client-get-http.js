'use strict'
// 07-client-get-http.js

const https = require('https')
const URL = "https://www.runoob.com/nodejs/nodejs-tutorial.html";

// http.get(url, callBack) 的回调函数callBack()只有一个参数response
/*
response 对象是一个 Stream 类型的对象，会触发一些事件
其中我们通常所需要关心的事件有三个："data"，"error" 以及 "end"
可以像这样来监听一个事件：response.on('data', function (data) {})
'data'事件会在每个数据块到达并已经可以对其进行一些处理的时候被触发

response 对象还有一个 setEncoding()方法
调用这个方法，并为其指定参数 utf8，事件中会传递字符串，而不是标准的 Node Buffer 对象
这样，你也不用再手动将 Buffer 对象转换成字符串了。
*/

https
  .get(URL, response => {
    response.setEncoding('utf8')
    response.on('data', console.log)
    response.on('error', console.error)
  })
  .on('error', console.error)
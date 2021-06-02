'use strict'
//12-server-pipe-operation.js

const http = require('http')
const map = require('through2-map')

/*
through2-map 允许你创建一个 transform stream
.pipe(map())可以完成「接收一个数据块，处理完后返回这个数据块」的功能
它的工作模式类似于Array.map()，但是是针对 stream 的

inStream.pipe(map(chunk => chunk.toString().toUpperCase())).pipe(outStream)

在上面的例子中，从 inStream 传进来的数据会被转换成字符串（如果它不是字符串的话）
全部大写后传入outStream，实现了管道式写法
*/

const server = http.createServer(function (req, res) {
  if (req.method !== 'POST') {
    return res.end('send me a POST\n')
  }

  req
    .pipe(map(chunk => chunk.toString().toUpperCase()))
    .pipe(res)
})

server.listen(Number(process.argv[2]))
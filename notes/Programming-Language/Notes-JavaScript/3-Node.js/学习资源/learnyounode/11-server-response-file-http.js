'use strict'
// 11-server-response-file-http.js

const http = require('http')
const fs = require('fs')

const server = http.createServer((request, response) => {
  /*
  request 和 response 都是 Node stream 对象
  可以使用流式处理（streaming）所抽象的那些方法来实现发送和接收数据
  */
  response.writeHead(200, { 'content-type': 'text/plain' })

  fs.createReadStream(process.argv[3])
    .pipe(response)
  /*
  fs 这个核心模块也含有一些用来处理文件的流式（stream） API
  fs.createReadStream(filePath) 为文件创建一个 stream 对象
  可以使用类似 src.pipe(dst) 的语法把数据从src流传输到dst流中
  这样就把一个文件系统的 stream 和一个 HTTP响应的 stream 联系起来

  pipe()实现了管道操作的写法
  */
})

// 命令行的第1个参数是端口，第2个参数是要返还给request的文件路径
server.listen(Number(process.argv[2]))
'use strict'
//10-server-time.js

// 核心模块 net
const net = require('net')

// 辅助函数：两位整数字符串，不足位用'0'补齐
function zeroFill(i) {
  return (i < 10 ? '0' : '') + i
}

// 格式化时间
function now() {
  const d = new Date()
  return d.getFullYear() + '-' +
    zeroFill(d.getMonth() + 1) + '-' +
    zeroFill(d.getDate()) + ' ' +
    zeroFill(d.getHours()) + ':' +
    zeroFill(d.getMinutes())
}

// 建立服务器
const server = net.createServer(function (socket) {
  // net.createServer()中的回调函数会被调用多次
  // 服务器每收到一个TCP连接，都会调用一次这个回调函数。
  socket.end(now() + '\n')
  /*
  socket.write(data) 可以写数据到 socket 中
  socket.end()可以关闭一个 socket
  .end()方法也可以接收一个数据对象作为参数
  因此，可简单地使用 socket.end(data)来完成写数据和关闭两个操作。
  */
}).listen(Number(process.argv[2])) // 以一个命令行参数为端口

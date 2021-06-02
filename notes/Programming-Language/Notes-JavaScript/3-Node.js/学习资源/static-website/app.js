// @ts-check
'use strict';
// app.js


const http = require('http');
const path = require('path');
const fs = require('fs');
const mime = require('mime');
// mime.getType(filename) 能根据文件的后缀名返回其对应的 Content-Type




http.createServer((req, res) => {

  if (req.url === '/') { // 默认返回主页 index.html
    req.url = '/index.html'
  }

  let filename = path.join(__dirname, 'public', req.url);
  fs.readFile(filename, (err, data) => {
    if (err) { // public文件夹中若找不到，则返回404
      console.error(err);
      res.end('404');
    } else { // public文件夹中若存在，则返回该资源
      res.setHeader('Content-Type', mime.getType(filename));
      res.end(data);
    }
  })

}).listen(9000, () => {
  console.log('http://localhost:9000')
})
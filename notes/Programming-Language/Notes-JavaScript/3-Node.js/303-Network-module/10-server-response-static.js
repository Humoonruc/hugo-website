// @ts-check
'use strict';
// 10-server-response-static.js

const fs = require('fs');
const path = require('path');
const http = require('http');
const PORT = 8899;


const server = http.createServer((request, response) => {
  response.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });

  if (request.url === '/' || request.url === '/index') {
    responsePage('index');
  } else if (request.url === '/login') {
    responsePage('login');
  } else if (request.url === '/picture/img.jpg') {
    fs.readFile(path.join(__dirname, 'picture', `img.jpg`), (err, data) => {
      if (err) return console.error(err);

      // 浏览器解析一个html文件过程中，发现需要请求图片资源
      // 服务器接收到新的request，以jpeg的格式返回图片字节流
      response.writeHead(200, { 'Content-Type': 'image/jpeg' });
      response.write(data);
      response.end();
    });
  } else if (request.url === '/css/index.css') {
    fs.readFile(path.join(__dirname, 'css', `index.css`), (err, data) => {
      if (err) return console.error(err);

      response.writeHead(200, { 'Content-Type': 'text/css' });
      response.write(data);
      response.end();
    });
  } else {
    responsePage('404');
  }

  //返回页面的函数
  function responsePage(pageName) {
    let filePath = path.join(__dirname, 'html', `${pageName}.html`);
    fs.readFile(filePath, (err, data) => {
      if (err) return console.error(err);
      response.write(`<h2>This is a simple web server on port ${PORT}.</h2><p>your request url is http://127.0.0.1:${PORT}${request.url}</p>`); // 发给client一段html文本
      response.write(data); // 发给client一个html文件
      response.end(); // 响应结束，client的浏览器开始解析所有接收到的内容：DOM树-渲染样式树-...
    });
  }

});


server.listen(PORT, () => {
  console.log(`Server running at http://127.0.0.1:${PORT}/`);
});
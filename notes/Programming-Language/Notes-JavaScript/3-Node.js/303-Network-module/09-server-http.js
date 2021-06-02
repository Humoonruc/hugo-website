//@ts-check
'use strict';


// 09-server-http.js

const http = require('http');
const PORT = 8000;

const server = http.createServer((request, response) => {
    response.statusCode = 200;
    // response.setHeader('Content-Type', 'text/plain'); // 返回纯文本，则即使response中包含html标签，也不会生效
    response.setHeader('Content-Type', 'text/html');
    response.write('<h2>Hello World!</h2>\nThis is a simple web server.');
    response.end(); // 必须有end()，浏览器才知道回应的结束

    //简写形式：
    // response.writeHead(200, { 'Content-Type': 'text/plain' });
    // response.end('Hello World\nThis is a simple web server.');
  })
  .listen(PORT);

console.log(`Server running at http://127.0.0.1:${PORT}/`);

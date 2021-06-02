[TOC]

# Node.js 网络模块

## http/https 搭建服务器

官方文档：http://nodejs.cn/api/http.html

http://nodejs.cn/learn/the-nodejs-http-module

http/https 是 Node.js 的原生网络模块，二者不能通用，都需要时必须同时 require.

```javascript
const http = require('http')
const https = require('https')
```

### http 服务器

```javascript
// @ts-check
'use strict';

const http = require('http');
const PORT1 = 8000;
const PORT2 = 8899;

// 1. 创建 http 服务对象
const server1 = http.createServer();

// 2. 监听 request 事件
server1.on('request', (request, response) => {
  // 收到任何request，都会返回 Hello world，需要写代码针对不同的request给出不同的处理
  response.statusCode = 200;
  response.setHeader('Content-Type', 'text/html; charset=utf-8'); //告诉浏览器用utf-8解码，这样才能正确显示中文
  response.write(`<h1>Hello World!</h1><p>This is a simple web server on ${PORT1}.</p><p>中文显示。</p>`);
  response.end(); // 必须有end()，浏览器才知道回应的结束，否则会一直转
})

// 3. 监听端口
server1.listen(PORT1, () => {
  console.log(`Server running at http://127.0.0.1:${PORT1}/`);
})

// 4. 可以链式简写
const server2 = http
  .createServer((request, response) => {
    response.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
    response.end(`<h1>Hello World!</h1><p>This is a simple web server on ${PORT2}.</p><p>中文显示。</p>`);
  })
  .listen(PORT2, () => {
    console.log(`Server running at http://127.0.0.1:${PORT2}/`);
  });
```

#### 路由控制

从URL到服务器返回内容的映射。

#### 服务器响应二进制资源

```js
// @ts-check
'use strict';
// 10-server-response-image.js

const fs = require('fs');
const path = require('path');
const http = require('http');
const PORT = 8899;

const server = http
  .createServer((request, response) => {
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
    } else {
      responsePage('404');
    }

    //封装一个返回页面的函数
    function responsePage(pageName) {
      let filePath = path.join(__dirname, 'html', `${pageName}.html`);
      fs.readFile(filePath, (err, data) => {
        if (err) return console.error(err);
          
        response.write(`<h2>This is a simple web server on port ${PORT}.</h2><p>your request url is http://127.0.0.1:${PORT}${request.url}</p>`); // 先发给client一段html文本
        response.write(data); // 发给client一个html文件
        response.end(); // 响应结束，client的浏览器开始解析所有接收到的内容：DOM树-渲染样式树-...
      });
    }

  }).listen(PORT, () => {
    console.log(`Server running at http://127.0.0.1:${PORT}/`);
  });
```

### request 对象

Class: http.IncomingMessage，继承自 stream.Readable

request 对象常用成员

- request.headers，返回一个对象
- request.rawHeaders，返回所有的键和值组成的字符串数组
- request.httpVersion
- request.method，包括 GET/POST/...
- request.url，不包含 Host 域名的路径，如：`/css/index.css`，`/public/logo.png`

### response 对象

Class: http.ServerResponse

response 对象常用成员

- `response.statusCode()`, `response.statusMessage()` 设置响应状态码及信息

  ```js
  response.statusCode(404)
  response.statusMessage('Page not found.')
  ```

- `response.setHeader(name, value)`, 设置响应报文头（header），必须放在 response.write() 和 response.end() 之前，即发送信息之前

- `response.writeHead(statusCode[, statusMessage][, headers])`，在一个函数内设置上面三个函数的内容

- `response.write()`, 发送响应主体（body）

- `response.end()`, 每次响应都必须调用，通知服务器响应已完成，服务器会在适当的时候关闭通信

### mime

`mime.getType(filename)` 能根据文件的后缀名自动返回其对应的 Content-Type

返回二进制文件时非常有用。

```js
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

  let filename = path.join(__dirname, 'static', req.url);
  fs.readFile(filename, (err, data) => {
    if (err) { // static 文件夹中若找不到，则返回404
      console.error(err);
      res.end('404, resource not found');
    } else { // static 文件夹中若存在，则返回该静态资源
      res.setHeader('Content-Type', mime.getType(filename));
      res.end(data);
    }
  })
    
}).listen(9000, () => {
  console.log('http://localhost:9000')
})
```



```js
// mime.js
module.exports = {
  ".html": "text/html",
  ".css": "text/css",
  ".js": "text/javascript",
  ".gif": "image/gif",
  ".ico": "image/x-icon",
  ".jpeg": "image/jpeg",
  ".jpg": "image/jpeg",
  ".png": "image/png"
};
```



### url

把很长、很复杂的url分析、解析为对象、便于操作的模块

[url | Node.js API 文档 (nodejs.cn)](http://nodejs.cn/api/url.html#url_the_whatwg_url_api)

[(10条消息) node.js中的url.parse已被弃用请使用URL类，通过GET发送数据（二）_laimaodashuaige的博客-CSDN博客_url.parse弃用](https://blog.csdn.net/laimaodashuaige/article/details/115968520)









### querystring

处理 url 中查询部分的字符串，将其反序列化为对象以及将对象序列化为查询字符串

## Web Client 模块

放在爬虫一节集中介绍。








// 使render()成为response对象的一个方法


// 1. 加载 http 模块
const http = require('http');
const fs = require('fs');
// const url = require('url');
const path = require('path');
const mime = require('mime');


// 2. 创建服务
http.createServer((request, response) => {

  response.render = function (filename) {
    const data = fs.readFileSync(filename);
    // fs.readFile(filename, (err, data) => {
    //   if (err) {
    //     response.writeHead(404, 'Not Found', { 'Content-Type': 'test/html;charset=utf-8', });
    //     response.end('404, not found.');
    //     return;
    //   }
    // });
    response.writeHead(200, { 'Content-Type': mime.getType(filename) });
    response.end(data);
  };


  // 设计路由
  // 当用户请求 / 或 /index 时，显示新闻列表
  // 当用户请求 /detail 时，显示新闻详情
  // 当用户请求 /submit 时，显示添加新闻页面
  // 当用户请求 /add 时，将用户提交的新闻保存到 data.json 文件中
  // 现根据用户请求的路径（路由），将对应的html显示出来

  if (request.url === '/' || request.url === '/index') {
    response.render(path.join(__dirname, 'html', 'index.html'));
  } else if (request.url === '/submit') {
    response.render(path.join(__dirname, 'html', 'submit.html'));
  } else if (request.url === '/item') {
    response.render(path.join(__dirname, 'html', 'detail.html'));
  } else if (request.url.startsWith('/add')) {
    // 1. 获取用户get提交的新闻数据。用户的提交会在url中，表现为 xx=xx&xx=xx 样式，url模块可以解析之 
    // 用户通过表单提交的url为：http://localhost:9090/add?title=aaaa&text=bbbb
    const reqURL = new URL(request.url, 'http://localhost:9090');
    console.log(reqURL);
    // 2. 把用户提交的数据保存在data.json中
    const params = {
      title: reqURL.searchParams.get('title'),
      text: reqURL.searchParams.get('text'),
    };
    console.log(params);
    fs.writeFileSync(path.join(__dirname, 'data', 'data.json'), JSON.stringify(params));
    // 3. 让用户的浏览器跳转到新闻列表页
    // 实现重定向，需要给浏览器发特定的响应报文头
    response.statusCode = 302; // 以3开头都表示跳转
    response.statusMessage = 'Found';
    response.setHeader('Location', '/'); // 跳转到根目录
    response.end();
  } else if (request.url === '/add' && request.method === 'post') {

  } else if (request.url.startsWith('/resources')) {
    response.render(path.join(__dirname, request.url));
  } else {
    response.writeHead(404, 'Not Found', { 'Content-Type': 'text/html; charset=utf-8', });
    response.end('404, Page note found.');
  }
}).listen(9090, () => {
  console.log('http://localhost:9090');
});

[TOC]

# Node Crawling

## HTTP clients 模块

### SuperAgent

功能全面，链式调用，体积较大。兼容浏览器和 Node.js

文档：https://visionmedia.github.io/superagent/

官网：https://www.npmjs.com/package/superagent

中文简介：https://www.jianshu.com/p/98b854322260%20

#### 三种规范写法

```javascript
const superagent = require("superagent")
const forumURL = "https://www.reddit.com/r/programming.json"

// callbacks
superagent
  .get(forumURL)
  .end((error, response) => {
    console.log(response)
  })

// promises
superagent
  .get(forumURL)
  .then((response) => {
    console.log(response)
  })
  .catch((error) => {
    console.error(error)
  })

// promises with async/await
async function getForum() {
  try {
    const response = await superagent.get(forumURL)
    console.log(response)
  } catch (error) {
    console.error(error)
  }
}
```

#### request config

##### header

`.set()`

```javascript
superagent
  .get(url)
  .set('Referer', 'https://www.google.com')
  .set('Accept', 'image/webp,image/*,*/*;q=0.8')
  .end(function (req, res) {
    //do something
  })
//等价于
superagent
  .get('/api')
  .set({
    'Referer': 'https://www.google.com',
    'Accept': 'image/webp,image/*,*/*;q=0.8'
  })
  .end(function (req, res) {
    //do something
  })
```

##### 参数

`.query()`

```javascript
superagent
  .get(url)
  .query({ name: 'An', age: 20, sex: 'male' })
  .end(cb)

superagent
  .get(url)
  .query('name=An&age=20&sex=male')
  .end(cb)

superagent
  .get(url)
  .query('name=An')
  .query('age=20')
  .query('sex=male')
  .end(cb)
```

##### 表单

`.send()`

```javascript
superagent
  .post(url)
  .type('form')
  .send({ name: 'An', age: 20 }) // name=An&age=20
  .end(cb)
```

##### 接收文件格式

默认的数据传递格式是JSON

`.accept()`

```javascript
superagent
  .post('/api')
  .accept('application/json')
  .accept('png')
```

##### 终止请求

`req.abort()` 

##### 等待时间

`req.timeout(ms)` `ms`表示毫秒为单位的时间

```javascript
.timeout({
    response: 5000,  // Wait 5 seconds for the server to start sending,
    deadline: 60000, // but allow 1 minute for the file to finish loading.
  })
```

##### Authentication

`Basic Access Authenication`，是通过直接提供用户名、密码来进行验证身份的一种优化的解决方案。

原理是将用户名和密码通过`:`连接,形成`username:password`然后再进行`base64`加密，发送到服务器后再进行解密得到用户名和密码,进行进一步的匹配验证。参考文章:[HTTP Basic Authentication认证](https://link.jianshu.com?t=http://smalltalllong.iteye.com/blog/912046)。

在`superagent`里，有两种方式进行验证

```javascript
superagent
  .get('http://username:password@localhost')
  .end(cb)
//等价于 ==>
superagent
  .get('http://localhost')
  .auth('username', 'password')
  .end(cb)
```

##### 添加多个附件

如果你想添加多个附件可以使用`attach(name,[path],[filename])`,其中你可以通过`filename`来自定义上传后文件的文件名

```javascript
request
  .post('/upload')
  .attach('avator', '/path/a.png', 'An.png')
  .attach('photo', '/path/b.png')
  .end(cb)
```

##### 错误处理

我们确实是可以从`end(function(err,res){...})`里的`err`得到错误信息,比如`er.status`错误的状态码啥的，但是有些时候我们想去处理这些错误，重新发送一个别的请求啥的，那么这个时候我们可以通过`on('error',handleFn)`去处理了

```javascript
request
  .post('/api')
  .send(data)
  .on('error', handleFn)
  .end(cb);
```



#### response 对象的属性

- `res.text` 响应的html
- `res.body` 包含解析的数据，但是目前只支持三种格式
- `res.header` 响应头,是一个`Object`
- `res.type ` 格式类型
- `res.charset`编码方式
- `res.status`状态码

#### 通过`pipe`管道流入流出数据

`node`核心特性就是`stream`，参考:[nodejs中流(stream)的理解](https://link.jianshu.com/?t=https://segmentfault.com/a/1190000000519006)

```javascript
//第一个例子
var fs = require('fs');
var superagent = require('superagent');
var postJson = fs.createReadStream('./postDataJson');
var req = superagent.post('/api');
req.accept('json');
stream.pipe(req);

//第二个例子
var fs = require('fs');
var superagent = require('superagent');
var getData = fs.createWriteStream('./getData');
var request = superagent.get('/api');
request.pipe(getData);
```



### Axios

https://github.com/axios/axios

[Getting Started | Axios Docs (axios-http.com)](https://axios-http.com/docs/intro/)

#### promise

默认 promise 范式而非 callback

```js
const axios = require('axios').default;

axios
  .get('https://www.reddit.com/r/programming.json')
  .then(response => {
    console.log(response)
  })
  .catch(error => {
    console.error(error)
  });

async function getForum() {
  try {
    const response = await axios.get('https://www.reddit.com/r/programming.json')
    console.log(response)
  } catch (error) {
    console.error(error)
  }
}
```

#### request config

https://axios-http.com/docs/req_config/

```js
// @ts-check
'use strict';

const axios = require('axios').default;

let request = {
  url: '/user',
  method: 'get', // 默认是 get，可以直接用.get()方法从而省略这一项
  baseURL: 'https://www.baidu.com/', // baseURL 将自动加在 url 前面，除非 url 是一个绝对 URL
  transformRequest: [function (data) {
    // transformRequest 允许在向服务器发送前，修改请求数据
    // 只能用在 'PUT', 'POST' 和 'PATCH' 这几个请求方法
    // 后面数组中的函数必须返回一个字符串，或 ArrayBuffer，或 Stream
    return data;
  }],
  transformResponse: [function (data) {
    // transformResponse 在传递给 then/catch 前，允许修改响应数据
    return data;
  }],
  headers: { 'X-Requested-With': 'XMLHttpRequest' },
  params: {
    // params 是 URL 参数
    // 必须是一个无格式对象(plain object)或 URLSearchParams 对象
    ID: 12345
  },
  paramsSerializer: function (params) {
    // paramsSerializer 是一个负责 params 序列化的函数
    // (e.g. https://www.npmjs.com/package/qs, http://api.jquery.com/jquery.param/)
    return Qs.stringify(params, { arrayFormat: 'brackets' })
  },
  data: {
    // data 是作为请求主体被发送的数据
    // 只适用于这些请求方法: 'PUT', 'POST', 和 'PATCH'
    // 在没有设置 transformRequest 时，必须是以下类型之一：
    // - string, plain object, ArrayBuffer, ArrayBufferView, URLSearchParams
    // - 浏览器专属：FormData, File, Blob
    // - Node 专属： Stream
    firstName: 'Fred'
  },
  timeout: 10000,
  // timeout 指定请求超时的毫秒数(0 表示无超时时间)
  // 如果请求话费了超过 timeout 的时间，请求将被中断
  withCredentials: false, // withCredentials 表示跨域请求时是否需要使用凭证
  adapter: function (config) {
    // adapter 允许自定义处理请求，以使测试更轻松
    // 返回一个 promise 并应用一个有效的响应 (查阅 [response docs](#response-api)).
    /* ... */
  },
  auth: {
    // auth 表示应该使用 HTTP 基础验证，并提供凭据
    // 这将设置一个 Authorization 头，覆写掉现有的任意使用 headers 设置的自定义 Authorization头
    username: 'janedoe',
    password: 's00pers3cret'
  },
  responseType: 'json', // 服务器响应的数据类型，可以是 'arraybuffer', 'blob', 'document', 'json', 'text', 'stream'
  xsrfCookieName: 'XSRF-TOKEN', // 用作 xsrf token 的值的cookie的名称
  xsrfHeaderName: 'X-XSRF-TOKEN', // 承载 xsrf token 的值的 HTTP 头的名称
  onUploadProgress: function (progressEvent) {
    // onUploadProgress 允许为上传处理进度事件
  },
  onDownloadProgress: function (progressEvent) {
    // onDownloadProgress 允许为下载处理进度事件
  },
  maxContentLength: 2000, // 定义允许的响应内容的最大尺寸
  validateStatus: function (status) {
    // 定义对于给定的HTTP 响应状态码是 resolve 或 reject  promise 。如果 validateStatus 返回 true (或者设置为 null 或 undefined)，promise 将被 resolve; 否则，promise 将被 rejecte
    return status >= 200 && status < 300; // 默认的
  },
  maxRedirects: 5, // 定义在 node.js 中 follow 的最大重定向数目。如果设置为0，将不会 follow 任何重定向
  httpAgent: new http.Agent({ keepAlive: true }), // httpAgent 和 httpsAgent 分别在 node.js 中用于定义在执行 http 和 https 时使用的自定义代理。允许像这样配置选项：keepAlive 默认没有启用
  httpsAgent: new https.Agent({ keepAlive: true }),
  proxy: {
    // 'proxy' 定义代理服务器的主机名称和端口
    // auth 表示 HTTP 基础验证应当用于连接代理，并提供凭据
    // 这将会设置一个 Proxy-Authorization 头，覆写掉已有的通过使用 header 设置的自定义 Proxy-Authorization 头。
    host: '127.0.0.1',
    port: 9000,
    auth: {
      username: 'mikeymike',
      password: 'rapunz3l'
    }
  },
  cancelToken: new CancelToken(function (cancel) {
    // cancelToken 指定用于取消请求的 cancel token
    // （查看后面的 Cancellation 这节了解更多）
  })
}


axios
  .request(request)
  .then(response => {
    // handle success
    console.log(response);
  })
  .catch(error => {
    // handle error
    console.log(error);
  })
  .then(function () {
    // always executed
  });
```

一些例子

```js
axios
  .request({
    method: 'post',
    url: '/user/12345',
    data: {
      firstName: 'Fred',
      lastName: 'Flintstone'
    },
    timeout: 1000,
    //...
  });


axios
  .get('demo/url', {
    params: {
      id: 123,
      name: 'Henry',
    },
    timeout: 1000,
    //...
  })

axios
  .post('demo/url', {
    id: 123,
    name: 'Henry',
  }, {
    timeout: 1000,
    //...
  })
```



#### response 对象的属性

```json
{
  data: {}, // `data` 由服务器提供的响应
  status: 200, // `status` 来自服务器响应的 HTTP 状态码
  statusText: 'OK', // `statusText` 来自服务器响应的 HTTP 状态信息
  headers: {}, // `headers` 服务器响应的头
  config: {} // `config` 是为请求提供的配置信息
}
```



### node-fetch

轻量级。

### got

轻量级。

### Request

https://github.com/request/request

考虑到其设计理念的古老，与现代JS越来越不兼容，作者已[不再更新](https://github.com/request/request/issues/3142)。

但仍有许多第三方模块依赖它。

```js
const request = require('request')
request('https://www.reddit.com/r/programming.json', (error, response, body) => {
  console.error('error:', error)
  console.log('body:', body)
})
```

### http/https

内置标准库。

写起来比较繁琐冗长，不推荐。

## HTML 解析模块

### Cheerio

类 jQuery 语法

https://github.com/cheeriojs/cheerio/wiki/Chinese-README

https://zetcode.com/javascript/cheerio/

```javascript
// 加载cheerio
const cheerio = require('cheerio');


let $ = cheerio.load('<ul id="fruits"><li class= "apple">Apple</li><li class="orange">Orange</li><li class="pear">Pear</li></ul>');

// 获取文本、属性和HTML
console.log($('.apple', '#fruits').text()) //$的第二个参数表示选择的范围
//=> Apple
console.log($('ul .pear').attr('class'))
//=> pear
console.log($.html('.pear'))
console.log($.root().html())

// 若干属性
console.log($('li').get(0).tagName)
console.log($('li').get().length)

// 遍历each()和筛选filter()
// 因箭头函数中this绑定错误，故若用this代表element，则回调函数不能用箭头函数
let fruits = [];
$('li').each(function (index, element) {
  fruits[index] = $(this).text();
});
console.log(fruits);
//=> Apple, Orange, Pear

// 若不用this，回调函数可以用箭头函数
fruits = [];
$('li').each((index, element) => {
  fruits[index] = $(element).text();
});
console.log(fruits);
//=> Apple, Orange, Pear
```

### JSDOM

JSDOM 用==纯 Javascript 在 Node 中实现 DOM==，可以用 JS 原生 API 进行操作。

JSDOM 最接近地模拟了浏览器环境，像点击按钮这样的事情是可以实现的。

```javascript
// 在Node中建立DOM
const { JSDOM } = require("jsdom");
const html = '<!DOCTYPE html><h2 class="title">Hello world</h2>';
const dom = new JSDOM(html);
const document = dom.window.document;

// 操作DOM
const heading = document.querySelector('.title');
heading.textContent = 'Hello there!';
heading.classList.add('welcome');
heading.innerHTML;
//=> <h2 class="title welcome">Hello there!</h2>
```

jsdom 可以与 d3 配合，在 Node.js 中绘制静态图片，然后使用命令

```shell
node drawCircle.js > mycircle.svg
```

导出为 .svg 文件

```js
/**
 * @module drawCircle
 * @file 使用 d3 和 JSDOM 模块绘制静态 SVG 图片
 * @author Humoonruc
 */

const d3 = require('d3');
const { JSDOM } = require("jsdom");

const jsdom = new JSDOM();
const document = jsdom.window.document;


const svg = d3.select(document.body).append('svg')
  .attr('xmlns', 'http://www.w3.org/2000/svg')
  .attr('width', 500)
  .attr('height', 500);

svg.append("circle")
  .attr("cx", 250)
  .attr("cy", 250)
  .attr("r", 250)
  .attr("fill", "Red");

console.log(document.body.innerHTML);
```







## 模拟浏览器模块

### Puppeteer: the headless browser

以编程的方式操作 Chrome 浏览器

API: https://github.com/puppeteer/puppeteer/blob/v3.0.2/docs/api.md

中文：https://zhaoqize.github.io/puppeteer-api-zh_CN/

实例：https://github.com/puppeteer/puppeteer/tree/main/examples

![puppeteer-hierachy](http://humoon-image-hosting-service.oss-cn-beijing.aliyuncs.com/img/typora/JavaScript/40333229-5df5480c-5d0c-11e8-83cb-c3e371de7374.png)

Puppeteer 可以让你像真人与浏览器互动

- 截图和生成 pdf
- 抓取单页应用并生成预渲染的内容。
- 自动化许多不同的用户交互，如键盘输入、表单提交、导航等。  



#### Linux

1. centos 中需要先安装好一个 chromium，puppeteer 才能正常使用

```bash
yum install chromium
```

2. 启动浏览器时的选项需要加一个属性： `  args: ["--no-sandbox", "--disable-setuid-sandbox"],`

```js
  const browser = await puppeteer.launch({
    headless: true, // Linux中必须为true
    args: ["--no-sandbox", "--disable-setuid-sandbox"], 
  });
```

3. 可能还需要安装一些依赖：https://github.com/puppeteer/puppeteer/blob/main/docs/troubleshooting.md#chrome-headless-doesnt-launch-on-unix

#### Examples

例1：截图和生成pdf

```javascript
// @ts-check
'use strict';

const puppeteer = require('puppeteer');

/*
截图和生成pdf
*/
async function getVisual(URL) {

  const browser = await puppeteer.launch({
    headless: false,
    slowMo: 200, //减慢浏览器的动作，可以看清发生了什么
    defaultViewport: { width: 1920, height: 1080, isMobile: false, },
  });
  let pages = await browser.pages();
  let page = pages[0];
  await page.goto(URL);


  await page.screenshot({
    path: './image/screenshot.png', //只能保存为png和jpg，一般用png
    // fullPage: true,
  });
  const backgroundImage = await page.$('div.h-inner');
  await backgroundImage.screenshot({ //仅截图元素
    path: './image/backgroundImage.png',
  });

  // await page.pdf({
  //   path: './image/page.pdf',
  //   displayHeaderFooter: false,
  //   format: 'a4'
  // });

  await browser.close();
}

// config
const URL = 'https://space.bilibili.com/306107070/channel/detail?cid=79090';
getVisual(URL);
```

例2：使用DOM API抓取网页内容

```js
// @ts-check
'use strict';

const puppeteer = require('puppeteer');


async function main(url) {
  const browser = await puppeteer.launch({
    headless: false,
    slowMo: 200, //减慢浏览器的动作，可以看清发生了什么
    defaultViewport: { width: 1366, height: 768, isMobile: false, },
  });
  const page = await browser.newPage();

  await page.goto(url);
  // await browser.waitForTarget(() => false); //启动浏览器时，不要自动关闭浏览器窗口

  const result = await page.evaluate(() => { 
    const headingList = [];
    document.querySelectorAll('.mw-headline')
      .forEach(heading => headingList.push(heading.innerHTML))
    return headingList;
  });

  console.log(result);
  await browser.close();
}


const url = 'https://en.wikipedia.org/wiki/Coronavirus';
main(url);
```

例3：下载百度图片

```js
// @ts-check
'use strict';
// baidu-image.js
// 完全模拟网页行为爬取百度图片

const puppeteer = require('puppeteer');
const fs = require('fs');
const path = require('path');
const https = require('https');


async function searchImage(subject) {
  const browser = await puppeteer.launch({
    headless: true,
    defaultViewport: { width: 1920, height: 1080, isMobile: false, },
    // 由于百度图片的惰性加载机制，height越大，加载的图片越多
  });
  const page = await browser.newPage();
  await page.goto('https://image.baidu.com/');


  // 1.在输入框中输入要搜索的东西并点击搜索
  await page.focus('#kw');
  await page.keyboard.sendCharacter(subject);
  await page.click('input.s_newBtn');
  console.log('click the button.');


  // 2.页面跳转
  page.on('load', async () => { //新页面加载完毕后运行函数
    console.log('page loading done.');

    // 解析 page，获取图片的 url
    const imageLinks = await page.evaluate(getImageLinks);
    console.log(imageLinks);

    // 下载图片
    for (let url of imageLinks) {
      await page.waitForTimeout(50); //降低下载频率，防止被封。该函数可以替代 sleep()
      downloadImage(url);
    }

    await browser.close();
  });
}

function getImageLinks() {
  const links = [];
  document.querySelectorAll('img.main_img')
    .forEach(image => links.push(image.getAttribute('src')));
  return links;
}

function downloadImage(url) {
  const ext = path.extname(url); // 扩展名
  const filePath = path.join(`./image/${Date.now()}${ext}`); // 保存路径
  const writeStream = fs.createWriteStream(filePath);

  const request = https.get(url, response => {
    console.log(response.statusCode);
    response.pipe(writeStream);
  });
  request.on('error', e => console.error(e));
  request.end();
}


// config
const subject = 'JavaScript';
searchImage(subject);
```

例4：绕过反爬机制爬取猫眼电影排行榜

```js
// @ts-check
'use strict';
// Maoyan-Puppeteer.js

const puppeteer = require('puppeteer');
const fs = require('fs');


async function main() {
  const browser = await puppeteer.launch({
    headless: false,
    slowMo: 200, //减慢浏览器的动作，可以看清发生了什么
    defaultViewport: { width: 1366, height: 768, isMobile: false, },
  });
  let pages = await browser.pages();
  let currentPage = pages[0];
  await currentPage.goto('https://www.baidu.com/');

  const inputArea = await currentPage.$('input#kw');
  await inputArea.type('猫眼电影排行榜', { delay: 100 }); // 在搜索栏输入
  await currentPage.click('input#su'); // 点击“百度一下”搜索框
  await currentPage.click('h3.t>a'); // 点击搜索结果的第一个链接，打开一个新页面

  pages = await browser.pages();
  currentPage = pages[1];
  await pages[0].close(); // 关闭百度页面

  // 全局变量
  let MovieTop100 = [];

  // 抓取10页
  for (let pageIndex = 2; pageIndex <= 11; pageIndex++) {
    // 提取信息
    const pageResult = await currentPage.evaluate(parsePage);
    console.log(pageResult);
    MovieTop100 = MovieTop100.concat(pageResult);

    // 不规律地暂停一段时间，防止被反爬虫
    await currentPage.waitForTimeout(Math.random() * 2000 + 2000);

    // 跳转到下一页并更新 currentPage
    if (pageIndex <= 10) {
      await currentPage.click(`a.page_${pageIndex}`);
      let pages = await browser.pages();
      currentPage = pages[0];
    }
  }

  // 保存到本地
  fs.writeFileSync('./data/MovieTop100.json', JSON.stringify(MovieTop100), "utf8");

    
  await browser.close(); // 关闭浏览器
}


async function parsePage() {
  const movieArray = [];
  document.querySelectorAll('dl.board-wrapper>dd')
    .forEach(movieNode => {
      const rank = +movieNode.querySelector('i.board-index').innerHTML;
      const title = movieNode.querySelector('p.name>a').innerHTML;
      const score = movieNode.querySelector('i.integer').innerHTML + movieNode.querySelector('i.fraction').innerHTML;
      let movieInfo = {
        rank: rank,
        title: title,
        score: score,
      };
      movieArray.push(movieInfo);
    });
  return movieArray;
}


main();
```





### headless-chrome-crawler

对 Puppeteer 的一个封装：https://github.com/yujiosaka/headless-chrome-crawler

```shell
npm i headless-chrome-crawler
```

## 爬虫框架

### node-crawler

https://node-crawler.readthedocs.io/zh_CN/latest/

https://github.com/bda-research/node-crawler





## 杂项模块

### 特殊符号编/解码

#### html-entities

在特殊符号和html之间编码解码，如`&lt;`对应`<`，`&quot;`对应`"`

https://github.com/mdevils/html-entities#readme

## 反爬与反反爬的军备竞赛

概览：https://www.scrapingbee.com/blog/web-scraping-without-getting-blocked/#conclusion

### 拟人工具

#### 伪造请求头

#### 无头浏览器

网站使用了越来越多的技术鉴别浏览器请求和爬虫请求，爬虫环境往往无法完全像浏览器一样运行 js 代码，这就成了一个鉴别爬虫的突破口。

釜底抽薪的解决方案是，真的操作浏览器去构造请求，这就是 headless brower 技术。

### 拟人行为

#### 代理 proxy

来自同一IP的高频、大量请求很容易被识别为爬虫。因此要使用不同的IP地址，即代理。

#### 验证码 Captcha

#### 请求模式

比如请求的 url 是有规律的，如果严格按规律执行，也很容易被识别为 robot.



### 模拟机器行为

有些XHR请求，我们需要找出它们、伪造它们以获得数据。








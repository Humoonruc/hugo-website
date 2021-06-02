[TOC]

## Client Request: Ajax/Fetch

现代JavaScript教程：https://zh.javascript.info/network

### Ajax

Asynchronous JavaScript + XML，这个技术改变了传统 Web 单击->等待接受和解析新页面的模式。

早期传输数据都用 XML，但现在绝大部分都是 JSON 了。

`XMLHttpRequest` 是一个内建的浏览器对象，它允许使用 JavaScript 发送 HTTP 请求，可以实现异步请求服务器资源，完毕后通过修改 DOM 将数据插入网页的功能。

```javascript
function updateDisplay(verse) {
  let url = verse.replace(" ", "").toLowerCase() + '.txt';

  let request = new XMLHttpRequest();
  request.open('GET', url);
  request.responseType = 'text';
  request.onload = function () {
    poemDisplay.textContent = request.response;
  };

  //以上都是XHR请求的设置。request 直到 send() 出去才会真正运行
  request.send();
}
```

### Fetch API

`fetch(url[, options])`，返回 Promise<object> 

- options
  - method, 默认为 GET
  - headers，指定 Request 的 headers 的属性值
  - body，要以 `string`，`FormData`，`BufferSource`，`Blob` 或 `UrlSearchParams` 对象的形式发送的数据（request body），注意 headers 对象中 Content-Type 属性的匹配
- 返回一个 Response 对象，有属性：
  - status
  - ok // 状态码为 200-299 时 ok 属性为 true
  - url，request 的完整 URL
  - headers 有 content-type 等属性
  - body 是一个 ReadableStream 对象



#### Request 对象

POST 发送 JSON

```js
// 千万不要忘记 fetch() 返回 promise，要放在 async 里面
(async () => { 
  let user = {
    name: 'John',
    surname: 'Smith'
  };

  let response = await fetch('/article/fetch/post/user', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json;charset=utf-8'
    },
    body: JSON.stringify(user)
  });

  let result = await response.json();
  alert(result.message);
})()
```



#### Response 对象

```javascript
let response = await fetch(url); // 返回 Response 对象
if (response.ok) { 
  let json = await response.json(); // 将 response.body 解析为json
} else {
  alert("HTTP-Error: " + response.status);
}
```

Response 对象提供了多种基于 promise 的方法，返回 Response.body 并解析为各种格式：

- `response.text()` —— 返回 Response.body 的文本形式
- `response.json()` —— 返回 JSON，
- `response.formData()` —— 返回`FormData` 对象
- `response.blob()` —— 返回[Blob](https://zh.javascript.info/blob)（具有类型的二进制数据）形式
- `response.arrayBuffer()` —— 返回[ArrayBuffer](https://zh.javascript.info/arraybuffer-binary-arrays)（低级别的二进制数据）形式

只能选择一种解析 Response.body 的方法。如果我们已经使用了 `response.text()` 方法，那么如果再用 `response.json()`，则不会生效，因为 body 内容已经被处理过了。

```js
let response = await fetch('https://api.github.com/repos/javascript-tutorial/en.javascript.info/commits');
let text = await response.text(); // 将 response.body 解析为文本
alert(text.slice(0, 80) + '...');


let response = await fetch('/article/fetch/logo-fetch.svg');
let blob = await response.blob(); // 下载资源为 Blob 对象
// 为其创建一个 <img>
let img = document.createElement('img');
img.style = 'position:fixed;top:10px;left:10px;width:100px';
document.body.append(img);
// 显示它
img.src = URL.createObjectURL(blob);
```

### 跨源资源共享

同源策略，即通信只能在相同域名、相同端口和相同协议的前提下完成。访问超出这些限制之外的资源会导致安全错误，除非使用了正式的跨域方案。这个方案叫作跨源资源共享（CORS，Cross-Origin Resource Sharing），定义了浏览器与服务器如何实现跨源通信。




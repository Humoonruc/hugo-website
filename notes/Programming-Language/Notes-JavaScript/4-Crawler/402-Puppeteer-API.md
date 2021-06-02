[TOC]

# Puppeteer API

API: https://github.com/puppeteer/puppeteer/blob/v3.0.2/docs/api.md

中文：https://zhaoqize.github.io/puppeteer-api-zh_CN/

实例：https://github.com/puppeteer/puppeteer/tree/main/examples

视频教程：[ABTester的个人空间 - 哔哩哔哩 ( ゜- ゜)つロ 乾杯~ Bilibili](https://space.bilibili.com/306107070/channel/detail?cid=79090)



## 浏览器 Browser

#### puppeteer.launch()

启动浏览器

```js
  const browser = await puppeteer.launch({
    headless: false,
    slowMo: 200, //减慢浏览器的动作，可以看清发生了什么
    defaultViewport: { width: 1366, height: 768, isMobile: false, },
  });
```



#### browser.newPage()

创建一个 Page 实例	

#### browser.close()

关闭浏览器

#### browser.pages()	

获取所有打开的 Page 实例	

打开多个tab页处理时切换page特别有用

## 选择器

调用方法的主体可以是 page，也可以是 ElementHandle 实例。

### 无回调函数

#### .$(selector)

底层调用的是 `document.querySelector`，返回 ElementHandle 实例，第一个匹配的DOM元素。

#### .$$(selector)

底层调用的是 `document.querySelectorAll`，返回所有匹配的 DOM 元素，是一个数组

### 有回调函数

#### .$eval(selector, node => {})

```javascript
const value = await page.$eval('input[name=search]', input => input.value);
const href = await page.$eval('#a", ele => ele.href);
const content = await page.$eval('.content', ele => ele.outerHTML);
```

#### .$$eval(selector, nodeArray => {})

```js
const items = await currentPage.$$eval('li div.title', nodes => nodes.map(node => node.innerHTML));
console.log(items);
```





## 页面 Page

### 跳转

#### page.goBack([options])

#### page.goForward([options])

#### page.goto(url[, options])

### 执行浏览器 API

#### `page.evaluate((...)=>{}, ...args)`

就像在浏览器环境下运行一个函数。page.evaluate()接受一个回调函数及其参数（可省略）并运行之。也可以接受字符串，并会将该字符串视为代码进行运算。

`.evaluate((...)=>{}, ...args)`比`$eval()`和`$$eval()`强大之处就在于==可以接收参数==，便利了操作。但要注意传入参数的位置.

```javascript
(async () => {
  const browser = await puppeteer.launch({
    headless: true,
    defaultViewport: { width: 1920, height: 1080, isMobile: false, },
  });
  const page = await browser.newPage();
  await page.goto('https://jr.dayi35.com');

  const documentSize = await page.evaluate(() => { // 获取窗口宽高
    return {
      width: document.documentElement.clientWidth,
      height: document.body.clientHeight,
    };
  });
  await page.screenshot({
    path: "example.png",
    clip: {
      x: 0,
      y: 0,
      width: 1920,
      height: documentSize.height // 按显示高度截图
    }
  });
  
  await browser.close();
})();
```



#### Page.exposeFunction

添加自定义函数

```javascript
// 给 Page 上下文的 window 对象添加 md5 加密函数
const puppeteer = require('puppeteer');
const crypto = require('crypto');

puppeteer.launch().then(async browser => {
  const page = await browser.newPage();
  page.on('console', msg => console.log(msg.text));
  await page.exposeFunction('md5', text =>
    crypto.createHash('md5').update(text).digest('hex')
  );
  await page.evaluate(async () => {
    // use window.md5 to compute hashes
    const myString = 'PUPPETEER';
    const myHash = await window.md5(myString);
    console.log(`md5 of ${myString} is ${myHash}`);
  });
  await browser.close();
});
```





### 事件 Events



### 操作

#### page.focus(selector)

将焦点置于某一元素

#### `page.screenshot([options])` 截图

- path: 截图保存路径
- fullPage: 如果设置为true，则对完整的页面（需要滚动的部分也包含在内）。默认是false



==elementHandle 也有对应方法，只截取某个元素的截图==

#### `page.pdf([options])`

保存为pdf

#### `page.waitForTimeout()`

暂停函数，可以替代 sleep()







## 元素 elementHandle

### 操作

#### `elementHandle.click([options])` 鼠标点击

#### `elementHandle.press(key[, options])` 键盘按键

#### `elementHandle.type(text[, options])` 键入文本

```js
const elementHandle = await page.$('input');
await elementHandle.type('Hello'); // 立即输入
await elementHandle.type('World', {delay: 100}); // 慢点输入，像真人
await elementHandle.press('Enter');
```



#### `elementHandle.uploadFile(...filePaths)` 上传文件

## 键盘 Keyboard

提供对键盘的精细控制：

```js
// 用键盘删除一些字符
await page.keyboard.type('Hello World!');
await page.keyboard.press('ArrowLeft');

await page.keyboard.down('Shift');
for (let i = 0; i < ' World'.length; i++)
  await page.keyboard.press('ArrowLeft');
await page.keyboard.up('Shift');

await page.keyboard.press('Backspace');
// 结果字符串最终为 'Hello!'
```

```js
// 键入 'A'
await page.keyboard.down('Shift');
await page.keyboard.press('KeyA');
await page.keyboard.up('Shift');
```

### API

#### keyboard.down(key[, options])

按下一个键且不放松

#### keyboard.up(key)

松开一个键

#### keyboard.press(key[, options])

按某个键一下且放松

#### keyboard.sendCharacter(char)

input 一个字符

```js
page.keyboard.sendCharacter('嗨');
```

该方法不会发送 `keydown` 或 `keyup` 事件

#### keyboard.type(text, options)

为文本中的每个字符发送一个`keydown`, `keypress`/`input` 和 `keyup` 事件。

要按下一个特别的键, 像 `Control` 或 `ArrowDown`. 请使用[`keyboard.press`](https://zhaoqize.github.io/puppeteer-api-zh_CN/#?product=Puppeteer&version=v8.0.0&show=api-keyboardpresskey-options)

```js
page.keyboard.type('Hello'); // 立即输入
page.keyboard.type('World', {delay: 100}); // 更缓慢的输入, 像一个用户
```



## 鼠标 Mouse

提供对鼠标的精细控制：
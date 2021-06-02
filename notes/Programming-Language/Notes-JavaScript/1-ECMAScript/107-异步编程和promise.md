[TOC]

## 异步编程和 promise

https://www.runoob.com/js/js-async.html

https://www.runoob.com/js/js-promise.html

https://developer.mozilla.org/zh-CN/docs/Learn/JavaScript/Asynchronous

### 基本概念

#### 同步执行与异步执行

异步（Asynchronous, async）是与同步（Synchronous, sync）相对的概念。

1. 同步执行：代码按书面顺序依次进入主线程（Call Stack），先进入的不执行完后面的不会执行
2. 异步执行
   1.  Call Stack 中若发现回调函数，则令其立刻离开 Call Stack，放入另一个（==浏览器或 Node.js 开辟和管理的==）线程执行，执行完毕后将其放入 Callback Queue
   2. 同时，主线程（ Call Stack中）继续执行后面的代码。Call Stack 变空后，将 Callback Queue 中的内容放入 Call Stack 中运行。
3. JavaScript 本身是一种同步的、会堵塞的、单线程（single threaded）的语言，但浏览器和 Node.js 是多线程的！JavaScript 引擎线程称为主线程，它负责解析 JavaScript 代码；其他可以称为辅助线程，这些辅助线程便是JavaScript实现异步的关键了！

![在这里插入图片描述](http://humoon-image-hosting-service.oss-cn-beijing.aliyuncs.com/img/typora/JavaScript/2020102517194866.png)

4. 并行执行是对一个程序真正的同时执行（通过多个CPU），是一种多线程的运行机制。同步执行和异步执行与单线程/多线程不是一个维度的概念。
5. 异步执行的在线动画演示：http://latentflip.com/loupe

#### callbacks 函数

回调函数可以用来控制函数的执行顺序和函数之间的数据传递。

并非所有的回调函数都是异步的，如`Array.forEach(callback)`中的回调函数就是同步的。

```javascript
function loadAsset(url, type, callback) {
  let xhr = new XMLHttpRequest();
  xhr.open('GET', url);
  xhr.responseType = type;

  xhr.onload = function() {
    callback(xhr.response);
  };

  xhr.send();
}

function displayImage(blob) {
  let objectURL = URL.createObjectURL(blob);

  let image = document.createElement('img');
  image.src = objectURL;
  document.body.appendChild(image);
}

loadAsset('coffee.jpg', 'blob', displayImage);
```



### 计时器

Timeouts and intervals

#### `setTimeout()`

设定和停止定时器：

```javascript
timeoutVariable = setTimeout(anonymousFunction, milliseconds);
clearTimeout(timeoutVariable) //停止执行尚未执行的timeout对象
```

在==指定的毫秒数后将回调函数加入任务队列==。如果执行同步任务的栈空了，队列按照先进先出原则将其中的回调函数压入栈中运行。至于回调函数进入队列后到底何时才出队列被执行，就不确定了。如果同步任务的执行时间很长，可能回调函数要在任务队列中等待一会儿。

```html
<p>点击第一个按钮等待3秒后出现"Hello"弹框。</p>
<p>点击第二个按钮来阻止第一个函数运行。（你必须在3秒之前点击它）。</p>
<button onclick="myFunction()">点我</button>
<button onclick="myStopFunction()">停止弹框</button>
<script>
    const myVar;
    function myFunction() {
        myVar = setTimeout(() => { alert("Hello"); }, 3000);
    }
    function myStopFunction() {
        clearTimeout(myVar);
    }
</script>
```

传递更多参数给`setTimeout()`的回调函数

```javascript
// @ts-check
'use strict';

let person = "Mr. Universe"
const myGreeting = setTimeout((/** @type {string} */ who) => {
    console.log('Hello, ' + who + '!');
}, 2000, person);
```

#### `setInterval()`

设定和停止循环器

```javascript
intervalVariable = setInterval(anonymousFunction, milliseconds)
clearInterval(intervalVariable)
```



```javascript
// 一个运行5秒的秒表计时器
function displayTime() {
    let time = new Date();
    document.querySelector('#demo').textContent = time.toLocaleTimeString();

const createClock = setInterval(displayTime, 1000)

const clearClock = setTimeout(() => {
    clearInterval(createClock);
    document.querySelector('#demo').textContent = "Clock stopped!";
    document.querySelector('#demo').style.color = 'red';
}, 5000);
```

一个真正的秒表：

```html
<!DOCTYPE html>
<html lang="zh">

<head>
    <meta charset="utf-8">
    <title>setInterval stopwatch</title>
    <style>
        p {
            font-family: sans-serif;
        }
    </style>
</head>

<body>
    <p class="clock"></p>
    <p>
        <button class="start">Start</button>
        <button class="stop">Stop</button>
        <button class="reset">Reset</button>
    </p>

    <script>
        // Define a counter variable for the number of seconds and set it to zero.
        let secondCount = 0;
        // Define a global to store the interval when it is active.
        let stopWatch;
        // Store a reference to the display paragraph in a variable
        const displayPara = document.querySelector('.clock');

        // Function to calculate the current hours, minutes, and seconds, and display the count
        function displayCount() {
            // Calculate current hours, minutes, and seconds
            let hours = Math.floor(secondCount / 3600);
            let minutes = Math.floor((secondCount % 3600) / 60);
            let seconds = Math.floor(secondCount % 60)

            // Display a leading zero if the values are less than ten
            let displayHours = (hours < 10) ? '0' + hours : hours;
            let displayMinutes = (minutes < 10) ? '0' + minutes : minutes;
            let displaySeconds = (seconds < 10) ? '0' + seconds : seconds;

            // Write the current stopwatch display time into the display paragraph
            displayPara.textContent = displayHours + ':' + displayMinutes + ':' + displaySeconds;

            // Increment the second counter by one
            secondCount++;
        }

        // Store references to the buttons in constants
        const startBtn = document.querySelector('.start');
        const stopBtn = document.querySelector('.stop');
        const resetBtn = document.querySelector('.reset');

        // When the start button is pressed, start running displayCount() once per second using setInterval()
        startBtn.addEventListener('click', () => {
            stopWatch = setInterval(displayCount, 1000);
            startBtn.disabled = true;
        });

        // When the stop button is pressed, clear the interval to stop the count.
        stopBtn.addEventListener('click', () => {
            clearInterval(stopWatch);
            startBtn.disabled = false;
        });

        // When the reset button is pressed, set the counter back to zero, then immediately update the display
        resetBtn.addEventListener('click', () => {
            clearInterval(stopWatch);
            startBtn.disabled = false;
            secondCount = 0;
            displayCount();
        });

        // Run displayCount() once as soon as the page loads so the clock is displayed
        displayCount();
    </script>
</body>

</html>
```

#### 递归的`setTimeout()`

递归的 `setTimeout()` 保证执行之间的时间间隔不变，不会受到回调函数运行时间的影响，在时间间隔上比`setInterval()`准确。

1. 用`clearTimeout()`结束：

```javascript
let i = 0;
let cycle;

function run() {
    console.log(i);
    i++;
    cycle = setTimeout(run, 100);
}

cycle = setTimeout(run, 100);

setTimeout(() => {
    clearTimeout(cycle);
}, 5000)
```

2. 用条件语句结束

```javascript
let i = 0;

const cycle = setTimeout(function run() {
    console.log(i);
    i++;
    if (i < 50) setTimeout(run, 100); 
}, 100);
```

#### `requestAnimationFrame()`

> 注意：node.js 中没有`requestAnimationFrame()`函数。

`requestAnimationFrame()`是现代版本的`setInterval()` —— 它在浏览器重新加载显示内容之前执行指定的代码块，从而允许动画以适当的==帧速率==运行，不管其运行的环境如何。

> 注意: 如果要执行某种简单的常规DOM动画, [CSS 动画](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Animations) 可能更快，因为它们是由浏览器的内部代码计算而不是JavaScript直接计算的。但是，如果您正在做一些更复杂的事情，并且涉及到在DOM中不能直接访问的对象(such as [2D Canvas API](https://developer.mozilla.org/en-US/docs/Web/API/Canvas_API) or [WebGL](https://developer.mozilla.org/en-US/docs/Web/API/WebGL_API) objects), `requestAnimationFrame()` 在大多数情况下是更好的选择。

```javascript
let rAF; //设为全局变量，才好调用 cancelAnimationFrame(rAF)
let startTime = null;

function draw() {
    let date = new Date;
    let timeStamp = date.getTime(); //返回秒数时间戳
    if (!startTime) {
        startTime = timeStamp;
    }
    let timeSpan = timeStamp - startTime;
    console.log(timeSpan);
    rAF = requestAnimationFrame(draw);
    // if (timeSpan > 10000) cancelAnimationFrame(rAF); // 用条件语句结束
}

draw();

setTimeout(() => {
    cancelAnimationFrame(rAF); // 定时结束
}, 5000)
```

`requestAnimationFrame()`在形式上很像递归，==不需要指定时间间隔==，它只是在当前条件下尽可能快速平稳地运行它。大多数屏幕的刷新率为60Hz，`requestAnimationFrame()` 总是试图==尽可能接近==60帧/秒的值。相比之下，`setInterval()`并不是针对设备优化的帧率运行，有时会丢帧。



### Promise 对象实现异步



大多数现代Web API都是基于promise的，因此你需要了解promise才能充分利用它们。这些API包括[WebRTC](https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API)，[Web Audio API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Audio_API)，[Media Capture and Streams](https://developer.mozilla.org/en-US/docs/Web/API/Media_Streams_API)等等。随着时间的推移，Promises将变得越来越重要，因此学习使用和理解它们是学习现代JavaScript的重要一步。

#### 术语

1. 创建promise时，它既不是成功也不是失败状态。这个状态叫作**pending**（待定）。
2. 当promise返回时，称为 resolved（已解决）.
   1. 一个成功**resolved**的promise称为**fullfilled**（**实现**）。它返回一个值，可以通过将`.then()`块链接到promise链的末尾来访问该值。` .then()`块中的执行程序函数将包含promise的返回值。
   2. 一个不成功**resolved**的promise被称为**rejected**（**拒绝**）了。它返回一个原因（**reason**），一条错误消息，说明为什么拒绝promise。可以通过将`.catch()`块链接到promise链的末尾来访问此原因。



#### promise 链式语法

```javascript
console.log('Starting');

fetch('coffee.jpg')
    .then(response => {
        console.log('It worked :)')
        return response.blob();
    }).then(myBlob => {
        let objectURL = URL.createObjectURL(myBlob);
        let image = document.createElement('img');
        image.src = objectURL;
        document.body.appendChild(image);
    }).catch(error => {
        console.log('There has been a problem with your fetch operation: ' + error.message);
    });

console.log('All done!');

// 输出的顺序可能是：
// Starting
// All done!
// It worked :)

// 因为 fetch() 取网络资源的后续操作被放到了事件队列中。
// 如果网速不好，获取资源很慢，主线程会执行下面的代码 console.log('All done!');
```

这里`fetch()`只需要一个参数—资源的网络 URL—返回一个 promise 对象. promise 是表示异步操作完成或失败的对象。可以说，它代表了一种中间状态。

promise 所代表的异步操作（`fetch()`的后续操作）被放入事件队列中，这样它们就不会阻止后续 JavaScript 代码的运行。排队操作将尽快完成，然后将结果返回到 JavaScript 主线程执行。

两个`then()` 块都包含一个回调函数，如果前一个操作成功，该函数将运行，并且每个回调都接收前一个成功操作的结果作为输入，因此您可以继续对它执行其他操作。每个`then()`块返回另一个promise，这意味着可以将多个`then()`块链接起来，依次执行多个异步操作。

如果其中任何一个`then()`块失败，则在末尾运行`catch()`块——`catch()`提供了一个错误对象，可用来报告发生的错误类型。但是请注意，同步try...catch不能与promise一起工作，尽管它可以与 async/await 一起工作，稍后您将了解到这一点。

#### promise 的优点：

1. promise对象的` .then()` 链式操作可读性更强，解决了回调金字塔的问题。
2. 所有的错误都由块末尾的一个`.catch()`块处理，而不是在“金字塔”的每一层单独处理。



当需要多次顺序执行异步操作的时候，适合用 Promise 而不是传统回调函数。例如，如果想通过异步方法先后检测用户名和密码，需要先异步检测用户名，然后再异步检测密码的情况下就很适合 Promise。

#### Promise.all()

允许等待多个 promise 完成，比如读取多个文件后再开始执行运算。D3.js 中有时需要读取多个文件后再运行代码，这时就需要 Promise.all()

```js
let a = fetch(url1);
let b = fetch(url2);
let c = fetch(url3);

Promise.all([a, b, c])
  .then(values => {
    //...
  });
```

==.map()==作为高阶函数，如果作为参数的函数返回promise，整体就会返回 promise 数组。

必须用 `Promise.all()` 统合它们，前面再加 await，才能阻塞主线程，等待多个 promise 全部完成再运行后面的代码。

```js
async function getDstArticle(src, from, to) {
  const srcArray = src.split('\r\n').filter(text => text !== '');
  const dstArray = await Promise.all(srcArray.map(async text => await getDstText(text, from, to)));
  // async 将函数返回值变为 promise，而 await 能够使程序在该 promise 处暂停
  // 但arr.map(async f)的返回值不是一个promise，而是promise数组，await arr.map(async f)是无法使程序在此处暂停的
  // 要用 await Promise.all(arr.map(async f)) 语法，才能够阻断主线程
  return dstArray.join('\r\n');
}
```

==注意：每个迭代不阻塞主线程，如此造成了事实上的并行访问服务器，无法真正控制访问的时间间隔==，可能被服务器视为恶意攻击。故访问服务器时，最好老老实实地用 for...of 循环。

#### .finally()

将`finally()`调用链接到链的末尾：

```js
function fetchAndDecode(url, type) {
  return fetch(url).then(response => {
    if(!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    } else {
      if(type === 'blob') {
        return response.blob();
      } else if(type === 'text') {
        return response.text();
      }
    }
  })
  .catch(e => {
    console.log(`There has been a problem with your fetch operation for resource "${url}": ` + e.message);
  })
  .finally(() => {
    console.log(`fetch attempt for "${url}" finished.`);
  });
}
```

这会将一条简单的消息记录到控制台，告诉我们每次获取尝试的时间。

#### new Promise()

将基本请求模型转换为使用promise：

```javascript
function promisifyRequest(request) {
  return new Promise(function(resolve, reject) {
    request.onsuccess = function() {
      resolve(request.result);
    };

    request.onerror = function() {
      reject(request.error);
    };
  });
}
```



这种返回值为一个 Promise 对象的函数称作 Promise 函数，可以应用链式语法，它常常用于开发基于异步操作的库。



### async和await

它们是基于 promises 对象的语法糖，使异步代码更易于编写和阅读。通过使用它们，异步代码看起来更像是老式同步代码

#### async

 `async` 关键字，把它放在函数之前，使其成为 [async function](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/async_function)，返回值为 promise 对象。JavaScript 引擎会添加必要的处理，以优化你的程序。

```javascript
async function hello() { return "Hello" };
hello().then(console.log)
```

#### await

==await 只在 async function 里面才起作用==。

它可以放在任何返回 promise 对象的异步函数之前（可以用`// @ts-check`帮助检查 await 是否有效，非常方便）。==await 关键字使JavaScript运行时暂停于此行，直到它后面这个promise 对象完成，您的代码才继续从下一行开始执行==。

您可以在调用任何返回 Promise 的函数时使用 await。

用更少的.`then()`块来封装代码，同时它看起来很像同步代码，所以它非常直观。

```javascript
async function myFetch() {
    let response = await fetch('coffee.jpg');
    return await response.blob();
}

myFetch()
    .then((blob) => {
        let objectURL = URL.createObjectURL(blob);
        let image = document.createElement('img');
        image.src = objectURL;
        document.body.appendChild(image);
    })
    .catch(e => {
        console.log('There has been a problem with your fetch operation: ' + e.message);
    });
```

注意：await 只能阻断一个promise；await Promise.all([promise, promise, ... ]) 才能阻断并行的多个 promise

#### ==爬虫常用==：在异步执行中实现确定的 sleep()

js 本身没有 sleep() 函数

```javascript
// 写一个类似其他语言的 sleep() 函数
const sleep = async delay => new Promise(resolve => setTimeout(resolve, delay));

async function main() {
  console.time('sleep function');
  await sleep(1000); // 暂停约1秒
  console.timeEnd('sleep function');
}

main(); //=> sleep function: 1.007s 
```














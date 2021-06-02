[TOC]

# Node.js 简介及模块系统

![imgbin_node-js-javascript-web-application-express-js-computer-software-png](http://humoon-image-hosting-service.oss-cn-beijing.aliyuncs.com/img/typora/JavaScript/imgbin_node-js-javascript-web-application-express-js-computer-software-png.png)

官方文档：https://nodejs.org/dist/latest-v14.x/docs/api/

中文版：http://nodejs.cn/api/

Stability: 绿色2级是稳定的，橙色1级是开发中，红色0级是已废弃。

## Node.js简介

Node.js is a JavaScript runtime built on Chrome's V8 JavaScript engine.

### Node.js 的特点

1. 设计思想：事件驱动
   1. 大部分API都是基于事件的、异步的，根据事件注册具体的回调函数，可以非常灵活地处理业务逻辑。
   2. 背景：Web 上数据密集型实时（data-intensive real-time）应用程序的迅速普及。如 Gmail 这种单页面、多 Ajax 请求的应用，前端有大量异步请求，需要服务后端有极高的响应速度。Twitter，Node 要处理数万条入站 tweet，用一个内存排队机制依次将其写入数据库。
2. 异步（非阻塞） I/O
   1. CPU的运算速度远高于I/O读写，如果总是要等待每一个 I/O 完成程序才能继续运行，无疑是浪费硬件的性能
   2. 异步方式并行处理大量 I/O 可以节省时间，非常适合 I/O 密集型场景
   3. Node 自身和浏览器一样，是多线程的，以此支持消息队列和异步 I/O
3. ==主线程（JavaScript 的线程）==为单线程
   1. js 代码不必关心多线程读写同一变量问题，兼具了线程安全和异步的高性能。缺点在于无法利用多核 CPU. 
   2. CPU 密集的纯计算场景，应该使用多线程方式计算。为了解决这个问题，用 child_process 模块开启子进程充分利用硬件资源，然后利用进程之间的消息来传递结果，将计算与 I/O 分离。
4. npm，最大的开源生态系统

### Node 全栈

传统后端 LAMP

- Linux
- Apache
- MySQL
- PHP

Node 全栈 MEAN

- MongoDB
- Express
- Angular
- Node.js

### 不需要 Web 容器

1. 传统模式，需要一个 Web 容器监听 8080 端口。静态资源由 Apache 直接读取，动态资源交给 PHP.

![image-20210408214606737](http://humoon-image-hosting-service.oss-cn-beijing.aliyuncs.com/img/typora/JavaScript/image-20210408214606737.png)



2. Node.js 不需要，它的进程本身就在监听 8080 端口。无论静态还是动态资源，都由 Node.js 处理。

![image-20210408214915326](http://humoon-image-hosting-service.oss-cn-beijing.aliyuncs.com/img/typora/JavaScript/image-20210408214915326.png)

## REPL & Shell

### REPL

Read-Eval-Print-Loop（交互式解释器）

类似于浏览器中的 Console

进入 REPL: `node`

退出 REPL: 按两次 Ctrl+C 或输入`.exit`（在 REPL 中输入 node 命令需要在前面加点，如`.help`）

### Shell 中的 Node

#### 严格模式

在服务器环境下，如果有很多JavaScript文件，每个文件都写上`'use strict';`很麻烦。

在 Shell 中运行 js 文件时，可以用参数让所有的 js 文件开启严格模式：`node --use_strict example.js`

#### 命令行参数

```shell
node --help
node -v # 查看版本
node -p # 运行并打印
node -p 'process.env' # 打印 process.env 的所有值

node xxx.js  ... 
# process.argv 是一个字符串数组，包括所接受的一行命令的所有部分，且其中元素为命令和文件的绝对路径。
# 则有 process.argv[0] 为 node 的绝对路径，process.argv[1] 为 xxx.js 的绝对路径，从 process.argv[2] 起是...所代表的诸参数。这些参数可以在 xxx.js 中使用。
```



## 全局变量

### global

与浏览器中的global有很大区别。

- 浏览器中，所有定义在函数外面的变量，都是global的一个成员；共享一个变量储存环境。

- 而 node 中定义在函数外面的变量仅存在于定义它的模块中，同名变量不会冲突。

  ```javascript
  console.log(gloabal);
  ```

### buffer

node中，Buffer类是大多数I/O的主要数据结构。==除非读写文件时指定编码==，否则文件的读写都会通过缓冲器进行。

### process

process对象提供了对Node环境和其运行环境的信息的访问，在node和运行环境之间架起了桥梁。

```bash
❯ node -p 'process.versions'
{
  node: '14.16.0',
  v8: '8.4.371.19-node.18',
  uv: '1.40.0',
  zlib: '1.2.11',
  brotli: '1.0.6',
  ares: '1.16.1',
  modules: '83',
  nghttp2: '1.41.0',
  napi: '7',
  llhttp: '2.1.3',
  openssl: '1.1.1g',
  cldr: '37.0',
  icu: '67.1',
  tz: '2020a',
  unicode: '13.0'
}
❯ node -p 'process.env'
❯ node -p 'process.release'
```

#### process 的标准 I/O

`process.stdin`和`process.stdout`都是buffer！

```js
// IO-demo.js
process.stdin.setEncoding('utf8'); // 只有通过设置编码，读入字符串而非 buffer，才有.trim()方法

process.stdin.on('readable', function () {
  const input = process.stdin.read();

  if (input !== null) {
    process.stdout.write(input); // echo the text
    const command = input.trim();
    if (command == 'exit')
      process.exit(0);
  }
});
```

#### process.argv 接受命令行参数

```js
// isPrimary.js
console.time('total time');

console.log(process.argv[0]);
console.log(process.argv[1]);
const bigNumber = process.argv[2];
isPrimary(bigNumber);

function isPrimary(number) {
  for (let i = 3; i <= Math.sqrt(number); i += 2) {
    if (number % i == 0) {
      console.log(`${number} has a pair of factors as ${i} and ${number / i}.`);
      return;
    }
  }
  console.log(`${number} is a primary.`);
}

console.timeEnd('total time');
```

然后在命令行输入

```shell
$ node ./isPrimary.js 217
```





## 模块（module）系统

### module vs package

#### module

为了编写可维护的代码，我们把很多函数分组，分别放到不同的文件里，这样，每个文件包含的代码就相对较少，很多编程语言都采用这种组织代码的方式。在Node环境中，一个.js文件就称之为一个模块（module），`hello.js`文件就是名为`hello`的模块。

使用模块还可以避免函数名和变量名冲突。相同名字的函数和变量完全可以分别存在不同的模块中，因此，我们自己在编写模块时，不必考虑名字会与其他模块冲突。

#### package

有package.json描述的模块，才叫包。

### 全局/非全局模块

全局模块使用时不需要 require() 加载，如 console 模块就是全局的，是 Node.js 提供的 API.

非全局模块使用前必须先通过 require() 加载

### 包管理工具 npm

#### node package manager

官网：https://www.npmjs.com/

文档：https://docs.npmjs.com/

```bash
npm -v
npm install npm@latest -g # 全局安装npm最新版本

npm help # 或 npm h 查看帮助

npm install mime --global/-g # 全局安装 mime 模块
mime a.png # 直接在cmd中使用 mime 命令

npm init # 在项目文件夹中创建 package.json 文件
npm init -y # y是yes的简称，全默认，不用选择，但项目文件夹的名称不能含大写字母或中文

npm install/i superagent # 将模块安装到项目文件夹/node_modules 目录下，但不记录在 package.json 中
npm install/i superagent --save-prod/-P # 将模块安装到项目文件夹/node_modules 目录下，同时使安装包的信息被记录在 package.json文件的dependencies属性中，这样能方便地管理包之间的依赖关系
npm install/i superagent --save-dev/-D # 将模块安装到项目文件夹/node_modules 目录下，同时使安装包的信息被记录在 package.json 文件的 devDependencies 属性中，仅供开发使用。一般测试模块等辅助开发工具会这样安装
npm uninstall superagent # 卸载

npm list # 查看当前目录下安装的模块
npm install # 自动安装所有项目依赖的（package.json中记载的）包
npm prune # 自动删除不必要的包
```

任何项目，最好都在项目文件夹中安装 node 模块。

==全局安装并不意为着不需要本地安装了，而是表明可以在 cmd 中直接使用该包所给予的命令==。

#### cnpm

国内有时用npm安装模块会出错，可以使用淘宝镜像cnpm：

```shell
npm install cnpm -g --registry=https://registry.npm.taobao.org
```

然后所有模块的安装都用`cnpm`命令（注意：cnpm命令只能在cmd中使用，不能在shell中使用）

#### nrm

在不同 npm 托管源之间切换，提高下载速度。（Windows不能用，Linux可以）

```shell
npm i nrm -g
nrm test # 不同源测速
nrm ls # 各个源的地址
nrm use cnpm #
```





### package.json

元数据

#### package.json

包含信息：
- name
- version
- main 入口文件
- dependencies
  - 只有项目直接依赖包的名称和版本号


#### package-lock.json

npm借鉴yarn的结果，第一次安装第三方包时会产生这个文件。

该文件保存了项目所有依赖包（及依赖包的依赖包）的名称、版本号、地址。

这样，再下载新包时，速度会快很多，重复被依赖的包也不必重复下载。



### CommonJS 标准模块加载原理与加载方式

#### require 导入模块

模块可以省略 .js 后缀。

如果只输入模块名而不输入路径，Node会依次在内置模块、全局模块和当前项目文件夹下查找模块（从脚本文件所在的文件夹依次向上，寻找 node_modules 文件夹）。

#### exports 导出模块

最好将需要导出的对象和函数封装为一个大对象，然后导出。

例1：main.js通过`require()`加载hello模块，然后在 cmd 中用`node main.js`运行即可。

```javascript
//hello.js
const greet = name => console.log('Hello, ' + name + '!');
module.exports = greet; //把函数greet暴露出去供其他模块使用
```

```javascript
//main.js
let greet = require('./hello'); // .js可以省略。
greet('Michael'); // Hello, Michael!
```

例2：数组的去重函数和求和函数

```js
// exports.js
const util = {
  noRepeat: arr => arr.filter((ele, index) => arr.indexOf(ele) == index), // 数组去重函数
  sum: arr => arr.reduce((ele1, ele2) => ele1 + ele2), // 数组求和函数
};
module.exports = util;
```

```js
// require.js
const arrFn = require('./exports');
const arr = [1, 2, 3, 3, 2];

let noRepeatArr = arrFn.noRepeat(arr);
let arrSum = arrFn.sum(arr);

console.log(noRepeatArr);
console.log(arrSum);
```

例3：百度翻译 API，注意异步的处理，以及导出的是一个对象，在写法上可读性更强。

```js
// baiduAPI.js
const md5 = require('md5');
const axios = require('axios').default;

const URL = 'http://api.fanyi.baidu.com/api/trans/vip/translate';
const appid = '百度翻译API账号';
const key = '百度翻译API密码';

async function translate(query, from, to) {
  const response = await axios.get(URL, {
    params: {
      q: query,
      appid: appid,
      from: from,
      to: to,
      salt: (new Date).getTime(),
      sign: md5(appid + query + (new Date).getTime() + key),
    },
    responseType: 'json',
  });
  return response.data;
}

module.exports.translate = translate;
```

```js
// translate.js
const baiduAPI = require('./baiduAPI');

const text = 'China\nJapan\nKorea\nUSA\nItaly\nFrance\ntrain';
const from = 'en';
const to = 'jp';

(async () => console.log(await baiduAPI.translate(text, from, to)))();
```

```bash
{
  from: 'en',
  to: 'jp',
  trans_result: [
    { src: 'China', dst: '中国' },
    { src: 'Japan', dst: '日本' },
    { src: 'Korea', dst: '韓国' },
    { src: 'USA', dst: 'アメリカ' },
    { src: 'Italy', dst: 'イタリア' },
    { src: 'France', dst: 'フランス' },
    { src: 'train', dst: '電車' }
  ]
}
```




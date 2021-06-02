[TOC]

# Node.js 核心模块

## 操作系统

### os

OS 模块的功能主要是获取操作系统的各种信息，便于跨平台适用。

### path

http://nodejs.cn/learn/the-nodejs-path-module

- `path.join()`，路径拼接（==自动适配各种操作系统，这非常重要==，避免了很多因为各系统路径不同导致的错误）
- `path.extname(pathString)`，返回扩展名
- `path.parse(pathString)`，将一个路径解析为一个对象，共有5个成员
  - root, 根目录（一般是磁盘名）
  - dir, 所在文件夹的完整目录
  - base, 路径最后一个部分（可能是文件名或文件夹名，若为文件名则包含扩展名）
  - ext, 扩展名
  - name, 文件名（不包含扩展名）
- `path.format(pathObject)`，将一个路径对象化为一个路径
- `path.normalize()`，规范化一个路径字符串
- `path.relative()`，返回两个路径之间的相对关系

#### 相对路径问题

执行 js 文件遇到相对路径时，相对的是执行 node 命令的路径，而不是相对于 js 文件。

为了解决这个问题：`__dirname`表示当前正在执行的 js 文件所在的目录的绝对路径，`__filename`表示当前正在执行的 js 文件的绝对路径。这两个值与 js 文件绑定，不受在哪个环境中执行 node 命令的影响。

使用`__dirname`和`__filename`不需要加载任何模块。

```js
// @ts-check
'use strict';
// absolute-path.js


const fs = require('fs');

let filename = __dirname + '/data/input.txt'
console.log('The filename to be read is ' + filename + '\n')

fs.readFile(filename, 'utf8', (error, data) => {
  if (error) return console.error(error);
  console.log('The words in the file are:\n' + data);
})
```

#### 路径拼接

```js
const path = require('path')
const fs = require('fs');

let filename = path.join(__dirname, 'data/input.txt')
// path.join()自动完成拼接功能，添加"/"或"\\"

fs.readFile(filename, 'utf8', (error, data) => {
  if (error) return console.error(error);
  console.log('The words in the file are:\n' + data);
})
```

#### 路径对象

```js
const path = require('path');
const str = 'C:/frontEnd/node/node.js';

let obj = path.parse(str);
console.log(obj);
```

```bash
{
  root: 'C:/',
  dir: 'C:/frontEnd/node',
  base: 'node.js',
  ext: '.js',
  name: 'node'
}
```



## I/O 模块

### 流(Stream)和管道(Pipe)模块

http://nodejs.cn/learn/nodejs-streams

流技术贯穿了整个Node核心，为HTTP和其他形式的网络请求提供支持。同时它也为文件系统提供了支持。

流对象是一个抽象接口，也就是说你不会直接去创建流，而是跟实现流的对象打交道，比如HTTP请求、文件系统的读写流、ZLib压缩或者process.stdout。

流的通用功能：

- 可以通过setEncoding来改变流数据的编码
- 可以检查流是否可读、是否可写，还是两者都可以
- 可以捕获流事件，比如接收数据或关闭连接等事件，并给这些事件分别设置回调函数
- 可以暂停和恢复流
- `.pipe()`可以把一个可读流中的数据通过管道传入一个可写流

#### 可读流



#### 可写流

### fs (file system)

http://nodejs.cn/learn/the-nodejs-fs-module

不同平台的文件系统是有区别的，fs 模块帮助我们屏蔽了这些底层的区别。

#### fs 方法的同步版和异步版

在 fs 模块中，I/O方法都有同步版和异步版。

同步版方法名都会以 'Sync' 结尾，会在错误发生时立刻抛出错误。用传统的 try...catch... 来捕获。

异步版第一个参数总是 error，最后一个参数都是回调函数。

小型程序写成同步版，可读性好；大型程序要用异步版，性能优、阻塞少。

#### 四个类

fs.FSWatcher，支持监听文件变化的事件

fs.ReadStream，可读流

fs.WriteStream，可写流

fs.Stats，从*stat函数返回的信息

#### Buffer（缓冲器）对象

Node中大部分跟二进制有关的功能还是用Buffer类来实现的。buffer是Node中的一个全局对象。

Buffer 对象是 Node 用来高效处理数据的方式，无论数据是文本文件还是二进制文件，或者其他的格式。==Buffer 可以通过调用 toString() 方法转换为字符串==。

`fs.readFile()`, `fs.writeFile()`和`fs.appendFile()`若不加编码参数，都默认读、写 buffer，必须加入编码参数`'utf8'`，才是读写字符串。

```js
const fs = require('fs')

// 默认读取为 Buffer 对象，是一个字节数组
fs.readFile("./data/input.txt", (err, data) => {
  if (err) console.log('Something wrong: ' + err);
  console.log(data)
});

// 将 Buffer 对象转换为字符串
fs.readFile("./data/input.txt", (err, data) => {
  if (err) console.log('Something wrong: ' + err);
  console.log(data.toString('utf8'))
});

// fs.readFile() 传入第二个编码参数，直接读为字符串
fs.readFile("./data/input.txt", 'utf8', (err, data) => {
  if (err) console.log('Something wrong: ' + err);
  console.log(data)
});
```

#### Promise 范式

```js
// @ts-check
// 上面这一行可以执行语法检查，如提示有些不返回promise的语句，加await是没有意义的
'use strict';


// 1. 回调范式
// 不用回调金字塔，就无法保证两个操作的相对顺序
const fs = require('fs')

fs.writeFile("./data/output1.txt", "我写入了一句话\n", 'utf8', err => {
  if (err) {
    console.log('Something wrong: ' + err);
  } else {
    console.log('f1');
  }
});

fs.writeFile("./data/output1.txt", "我追加了一句话\n", 'utf8', err => {
  if (err) {
    console.log('Something wrong: ' + err);
  } else {
    console.log('f2');
  }
});
//=> 输出可能是 f1 f2，也可能是 f2 f1
// output1.txt中追加的内容可能被写入的内容覆盖


// 2. async/await 范式
// 确保两个写入的顺序
// 需要引入 promise 版 fs 模块
const fsPromise = require('fs/promises');

async function writeToFile() {
  try {
    await fsPromise.writeFile("./data/output2.txt", "我写入了一句话\n", "utf8");
    console.log('p1');
    await fsPromise.appendFile("./data/output2.txt", "我追加了一句话\n", "utf8");
    console.log('p2');
  } catch (error) {
    console.log('Something wrong: ' + error);
  }
}
writeToFile();
//=> 输出一定是 p1 p2
```

#### 创建目录

```js
const fs = require('fs');

fs.mkdir('test-mkdir', error => {
  if (error) return console.error(error);
  console.log('success');
})
```

#### 读写 stream

`fs.createReadStream(path, options)`

`fs.createWriteStream(path, options)`

```javascript
// @ts-check
'use strict';

const fs = require('fs');
const path = require('path');
const superagent = require('superagent');

const filePath = path.join(`./image/${Date.now()}.jpg`);
const writeStream = fs.createWriteStream(filePath);
const response = superagent.get('https://images2018.cnblogs.com/blog/1072774/201803/1072774-20180305002327704-1596258521.png');
response.pipe(writeStream); //保存图片
```

#### 更改文件名称

`fs.renameSync(oldpath, newpath)`

#### 删除文件

`fs.unlinkSync(filepath)`

#### 查询文件 metadata

`fs.stat()`

```js
const fs = require('fs');
console.log(fs.statSync('./5-1.js'))
```

### node-CSV

解析csv文件的模块。

```bash
npm install csv
```

```js
const CSV = require('CSV');

const generator = CSV.generate({ seed: 1, columns: 2, length: 20 });
const parser = CSV.parse();
const transformer = CSV.transform(data => {
  return data.map(value => value.toUpperCase());
});
const stringifier = CSV.stringify();

generator.on('readable', () => {
  while (data = generator.read()) {
    parser.write(data);
  }
});
// 解析生成的csv文件
parser.on('readable', () => {
  while (data = parser.read()) {
    transformer.write(data);
  }
});
// CSV转换为txt
transformer.on('readable', () => {
  while (data = transformer.read()) {
    stringifier.write(data);
  }
});

stringifier.on('readable', () => {
  while (data = stringifier.read()) {
    process.stdout.write(data);
  }
});
```



## 与 Shell 通信模块

### child_process

API: http://nodejs.cn/api/child_process.html#child_process_child_process



在 node 中运行系统命令，使用操作系统的功能。

书中本章大部分代码是 Linux 和 Mac 版的，Windows PowerShell 版代码在此：

[(10条消息) Node.js学习指南第二版第8章child_process子进程Windows版本命令示例_Coding home - 漂流瓶jz-CSDN博客](https://blog.csdn.net/qq278672818/article/details/108684686)

#### .spawn() 和.spawnSync()

该方法的异步版会实时返回一个 stream，可以实时打印运行中的输出。child_process 只有这个方法可以做到这一点。

Windows 版本要设置 `child_process.spawn(命令, [参数数组], {shell: true})`

```js
// chap8-1.js
const child_process = require('child_process');
const pwd = child_process.spawn('pwd'); // 执行系统的 'pwd' 命令，pwd是一个buffer类的变量

// pwd.stdout 监控子进程的输出，即向shell输入'pwd'后的输出
pwd.stdout.on('data', data => console.log('stdout: ' + data));

// pwd.stdout 监控子进程是否出现了错误
pwd.stderr.on('data', data => console.error('stderr: ' + data));

// 子进程关闭时触发第二个参数的回调，打印结束代码。无错误时返回0
pwd.on('close', code => console.log('child process exited with code ' + code));
```

```js
  const stream = child_process.spawn('node', ['./scripts/translate.js', mdPath]);
  stream.stdout.on('data', (data) => {
    console.log(`stdout: ${data}`);
  });
  stream.on('close', (code) => {
    console.log(`child process exited with code ${code}`);
  });
```

#### .exec() 和 .execSync()

很像Python中的 `os.system('')`，没有返回值，而是采取回调函数的形式。

第一个参数分别是命令行输入。

第二个参数分别是一些 options（包括 encoding 等）。

第三个参数是回调函数。回调函数接受三个参数：err, stdout, stderr。若未发生错误，则运行结果会被缓存到 stdout 中。

stdout 不会实时输出，而是最后一起输出。

```js
const childProcess = require('child_process');

const shellString = 'node example8-1.js';
childProcess.exec(shellString, function (err, stdout, stderr) {
  if (err) {
    console.log('Something error:' + stderr);
  } else {
    console.log(stdout); // 由于 example8-1.js 中已经把输出转换为字符串格式了，所以这里直接输出即可
  }
});

const output = child_process.execSync(`node ./scripts/translate.js ${mdPath}`, { encoding: 'utf8' });
console.log(output);
```

#### .execFile() 和 execFileSync()

第一个参数是 Shell 脚本文件路径。

第二个参数分别是 Shell 脚本可以接受的参数、值数组（命令行参数被分离为数组中的不同元素，按照一个参数、一个值的顺序排列）

第三个参数是回调函数，同`.exec()`

由于`child_process.execFile()`并没有创建新的shell，所以在某些情况下就无法使用。Node文档提醒我们，不能在I/O重定向和通过使用路径扩展进行文件通配（通过正则表达式或通配符）时使用这个函数。

但是，如果你在尝试交互地运行一个子进程（或者程序），那么你应该使用child_process.execFile()而不是child_process.exec()。

```js
'use strict';

// 这段代码并非要运行一个shell脚本，但由于是要在原本的shell内输入node进入交互式REPL并持续接受输入，所以只能用 .execFile()
const cp = require('child_process');
const child = cp.execFile('node', ['-i'], (err, stdout, stderr) => {
  console.log(stdout);
});

child.stdin.write('2+2;\n'); // 注意这个回车，若无回车，命令行会将这个字符串和下一行的字符串看成同一行的命令而报错
child.stdin.write('process.versions;\n'); 
child.stdin.end();
```



#### .fork()

新开一个进程，使用一个新的 V8 实例。

Node 中的 cluster(集群) 模块就是基于 child_process.fork() 实现的。

#### 进程间通信

《深入浅出 Node.js》第 9 章

### 创建命令行工具

js 文件顶部加入`#!/usr/bin/env node`，保存文件时去掉 .js 后缀，比如文件名为 commandLineScript

然后用 chmod 命令将其转换为可执行文件：

```bash
chmod a+x commandLineScript
```

便可以使用这个工具了：

```bash
./commandLineScript -h # 获取帮助
./commandLineScript xx xx xx # 传入参数
```

### ReadLine

使 Node 开启一个不会自动终止的线程，用来进行数据通信

```js
const readline = require('readline');
```

一旦引入这个模块，Node 程序就永远不会终止直到交互界面被手动关闭。

## 事件模块

http://nodejs.cn/learn/the-nodejs-events-module



## Assert

[assert | Node.js API 文档 (nodejs.cn)](http://nodejs.cn/api/assert.html)

`assert.strictEqual(actual, expected[, message])`

```js
const assert = require('assert').strict;
assert.strictEqual(Math.max(1, 100), 100);
// 一旦不相等，assert.equal() 就会抛出 AssertionError 异常
```


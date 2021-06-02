[TOC]


本项目官网地址：https://zh.javascript.info/

# 现代 JavaScript 教程

## JavaScript 基础语法

### 运行环境

#### 操作系统 Shell

在shell/terminal中输入 `node` 

#### 浏览器 Console

浏览器中按 F12 出现

#### 嵌入HTML

将脚本嵌入 HTML，在浏览器引擎中执行
1. 行内：在标签内部属性的值处写 js 代码
2. 内嵌：可以使用 `<script></script>` 标签将 JavaScript 代码嵌入。
   1. `<script>`标签的`type` 和 `language` 特性（attribute）不是必需的。
   2. 一个 `<script></script>` 标签不能同时有 `src` 特性和内部包裹的代码。若同时存在，内部包裹的代码将不会被执行。
3. 外部脚本：通过 `<script src="path/to/script.js"></script>` 的方式引用
4. 通常将 js 脚本放在 HTML 文档最末、`</body>`标签之前。这样浏览器就会先渲染HTML，后下载和执行脚本，有利于提升页面的性能。（如果脚本在`<head></head>`中，则会等到脚本下载、解析完毕之后，才渲染页面。）
5. `<script>` 元素会按照它们出现在 html 中的次序执行。

```html
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Document</title>
</head>

<body>
    <div>
        <p>
        </p>
    </div>
    
    <!-- 行内 -->
    <button onclick="alert('行内js代码,button')">单击试试</button>
    <!-- 内嵌 -->
    <script>
        alert("嵌入js代码，页面加载就会执行");
    </script>
    <!-- 外部脚本 -->
    <script src="pop.js"></script>
</body>

</html>
```

### 交互环境

#### 浏览器弹窗

- 警告框 `alert(text)`

  显示信息。

- 提示框 `prompt(text, [default])`

  显示==提示信息== text，出现一个输入框，要求用户输入文本，作为该函数的返回值。文本框的默认值为第二个参数。若第二个参数被省略，则缺省值为`undefined`。点击取消或按下 Esc 键返回 `null`。

- 确认框 `confirm(question)` 

  显示提示信息（question），并==等待用户点击确定或取消。点击确定返回 `true`，点击取消或按下 Esc 键返回 `false`==。
  
- 弹窗信息使用 `\n` 来设置换行。

这些方法都是==模态==的：它们暂停脚本的执行，并且不允许用户与该页面的其余部分进行交互，直到窗口被解除。

#### 浏览器 console 和操作系统 REPL

1. 实时输出函数 `console.log()` 可以查看变量的值。

3. 浏览器开发者工具的Sources选项卡可以通过Snippets创建临时脚本片断，调试多于一行的代码很方便。

#### 程序计时器 `console.time()`

`console.time()`和`console.timeEnd()`配合，成对地传入同一个参数，便能统计之间的代码运行时间。

```js
// time.js
console.time('total time');

console.time('time1');
for (var i = 0; i < 10000; i++) { }
console.timeEnd('time1');

console.time('time2');
for (var i = 0; i < 100000; i++) { }
console.timeEnd('time2');

console.timeEnd('total time');
```

```bash
$ node time.js
time1: 0.185ms
time2: 1.846ms
total time: 9.557ms
```



#### 浏览器界面

1. `document.write()`

   1. 向HTML中插入文本和DOM元素，相当于添加在原有html代码中添加一串html代码，类似于打印效果。
   2. 注意：如果在文档加载完毕后再使用`document.write`（比如在函数中），会刷新页面覆盖整个文档。因此这个功能其实很少用。

   ```html
   <!DOCTYPE html>
   <html>
   
   <head>
       <meta charset="utf-8">
       <title>菜鸟教程(runoob.com)</title>
   </head>
   
   <body>
   
       <h1>我的第一个 Web 页面</h1>
       <p>我的第一个段落。</p>
       <button onclick="myFunction()">点我</button>
       <script>
           // 调用此函数会覆盖之前的所有内容
           function myFunction() {
               document.write(Date());
           }
       </script>
   
   </body>
   
   </html>
   ```

2. 为 `innerHTML`赋值，从而写入HTML元素。这个更常用，而且性能不错。

### 代码结构

#### 语句

1. 以分号 `;` 结束，为了代码的可读性，最好不要省略。
2. `eval(string)`可以将一个字符串解析为命令语句并执行，不管这个字符串多长。
3. 使用 `,` 将多个语句分开。每个语句都运行了，但是只有最后的语句的结果会被返回。

```javascript
let width = 800, height = 600; //写在一行里能提高编译速度
```

4. 标签语句：用于 break 和 continue 的跳转

```javascript
start: for (let i = 0; i < count; i++) { 
    console. log( i); 
}
```



#### 注释

1. 单行注释`//`。vscode中的快捷键：`Ctrl + /`
2. 多行注释`/*  */`。由于正则表达式也用到了`/`和`*`符号，所以==多行注释有时是不安全的==。推荐使用单行注释。

#### 换行

对于太长的字符串，可以用反斜杠`\`换行。

```javascript
console.log("你好\
世界!"); // 你好世界！
```

### 变量和标识符

#### 声明变量

1. `let` 关键字声明变量[^let]（取代陈旧的`var`）。

   2. 只声明而不初始化，则变量的值为 undefined. ==最好保持声明变量时立即初始化的习惯，这样在 typeof(x) 返回 undefined 时，我们就能立刻意识到：x 尚未被声明==。
   2. 一条语句可以声明多个变量，可以横跨多行。
   3. `let`不允许声明已声明过的变量。
   4. `let`和下面的`const`都具有块级作用域。

   ```javascript
   function varTest() {
       var x = 1;
       if (true) {
           var x = 2;       // 函数作用域，两个x是同一个变量的重新声明!
           console.log(x);  // 2
       }
       console.log(x);  // 2
   }
   
   function letTest() {
       let x = 1;
       if (true) {
           let x = 2;       // 块级作用域，不同的变量    
           console.log(x);  // 2  
       }
       console.log(x);  // 1
   }
   ```

[^let]: JavaScript 在设计之初，为了方便初学者学习，并不强制要求声明变量。这个设计错误带来了严重的后果：如果一个变量没有经过声明，该变量就自动被声明为全局变量。在同一个页面的不同 JavaScript 文件中，如果都恰好都使用了变量`i`，将造成变量`i`互相影响，产生难以调试的错误结果。为了修补JavaScript这一严重设计缺陷，ECMA在后续规范中推出了strict模式，在strict模式下运行的JavaScript代码，强制声明变量，未声明变量就使用的，将导致运行错误。现在如果我们不在脚本中使用 `use strict` 声明启用严格模式，仍然可以正常工作，这是为了保持对旧脚本的兼容。


2. `const`声明一个不可赋值的常量，==声明时必须进行初始化==，且初始化后不可修改。

   1. 用 const 声明的对象，可以修改或重新赋值对象的属性。但不能对这个对象整体重新赋值。
   2. ==能用 const 就不用 let，除非已知变量的值会改变==。

```javascript
// 创建常量对象
const car = {type:"Fiat", model:"500", color:"white"};
car.color = "red";
car.owner = "Johnson";

// 报错
car = {type:"Volvo", model:"EX60", color:"red"}; //Uncaught TypeError: Assignment to constant variable.
```



3. JavaScript 拥有动态类型，即变量类型均可变。
4. 声明变量时，可以用`new`表明类型。`let carname = new String;`

#### 标识符

3. 标识符（变量、函数、属性、参数名）是大小写英文字母、数字、`$`和`_`的组合，且不能用数字开头。
4. 一般用大写字母和下划线命名那些在执行之前就已知的、但难以记住的值。如 `const COLOR_ORANGE = "#FF7F00";`

### 数据类型

#### 八种基本数据类型

前七种为值类型，也称为原始类型，而 `object` 为引用类型、复杂数据类型。

##### number

`number` 用于32位整数或64位浮点数，以及 `Infinity`、`-Infinity` 和 `NaN` 等特殊数值。

其中`Infinity`表示无穷大（如`1/0`的运算结果），`NaN`表示计算错误。

过大或过小的数字可以用科学计数法表示：`let x = 123e5`, `let y = 123e-5`。

1. number.toString(2/8/16)可以将整数转化为2、8、16进制的字符串
2. `number.toFixed(k)`可以将浮点数保留k位小数

##### bigint

用于任意长度的整数，形式为将`n`加在整数字段的末尾，如`1234567890123456789012345678901234567890n`。

##### string

字符串

##### boolean

`true` 和 `false`

##### null

只有一个 `null` 值的独立类型，表示连定义都没有。所以可以给变量赋值 `null` 来清空变量（值为`null`的变量本质上是一个指向空对象的指针）。

##### undefined

`undefined` 用于尚未声明的变量名，以及已被声明、但尚未定义的变量。

##### symbol

用于创建对象的唯一标识符。

##### object

一组由键-值对组成的无序集合，键-值对又称为对象的属性。对象是属性的容器。

#### 查看数据类型

可以通过 `typeof` 运算符查看存储在变量中的数据类型。

1. 两种形式：`typeof x` 或者 `typeof(x)`。
2. 以字符串的形式返回类型名称
   1. “undefined”
      1. 尚未被声明的标识符和已经声明但尚未赋值的变量都会返回 undefined. 为了避免混淆，建议变量声明时都立即赋值。
      2. 判断某个全局变量是否存在用`typeof(window.myVar) === 'undefined'`
      3. 判断某个局部环境中变量是否存在用`typeof(myVar) === 'undefined'`
   2. “boolean”
   3. “string”
   4. “number”
   5. “object”，对象或 null
      1. null 是一个指向空对象的指针，因此`typeof(null)`的结果是 object. 要判断变量`x`是否`null`只能用 `x === null`
      2. `typeof Array` 也会返回 `"object"`（因 Array 在 JavaScript 中不是一种数据类型，而是一种数据结构），所以要判断一个对象 arr 是否是数组，要使用`Array.isArray(arr)`；
   6. “function”
      1. JavaScript 中==函数隶属于 `object` 类型。但是 `typeof` 会对函数区别对待，并返回 `"function"`。==这也是来自于 JavaScript 语言早期的问题。==从技术上讲，这种行为是不正确的，但在实际编程中却非常方便==。
   7. “symbol”

#### 数据类型转换

##### 字符串转换

1. `+` 运算符转换：`+` 连接的两个运算元，只要有一个是字符串，另一个也会被转化为字符串。所以将变量 x 转换为字符串的最简单方式是：

   ```javascript
   let x2string = x + "";
   ```

2. 调用对象的`toString()`方法转化表达式为字符串。

   1. 但`null`和`undefined`没有`toString()`方法。

   2. 字面量形式的数字调用`toString()`报SyntaxError：

      ```javascript
      123.toString(); // SyntaxError，因为解析器把"."理解成了小数点
      ```

      遇到这种情况，要特殊处理一下：

      ```javascript
      123..toString(); // 注意是两个点！
      (123).toString();
      ```

   3. 函数对象调用`toString()`返回函数的表达式

3. `String()` 显式转换

   1. 如果参数有`.toString()`方法，则调用方法
   2. 若参数为 undefined，则返回 undefined
   3. 若参数为 null，则返回 null

4. 尝试输出一个变量，JavaScript 会自动调用变量的 toString() 方法进行转换（隐式转换），如 `alert(value)`，`document.write(value)`时。

   ```javascript
   document.getElementById("demo").innerHTML = myVar; // 页面显示转换后的字符串内容
   
   myVar = [1,2,3,4]       // 转换为 "1,2,3,4"
   myVar = new Date()      // 转换为 "Fri Jul 18 2014 09:08:55 GMT+0200"
   myVar = 123             // 转换为 "123"
   myVar = true            // 转换为 "true"
   myVar = false           // 转换为 "false"
   ```

5. 数字转换为字符串时的格式化

| 方法               | 描述                                                         |
| :----------------- | :----------------------------------------------------------- |
| `.toExponential()` | 把对象的值转换为指数计数法。                                 |
| `.toFixed(n)`      | 把数字转换为==字符串==，结果的小数点后有指定位数(n)的数字（四舍五入），不足补0。 |
| `.toPrecision()`   | 把数字格式化为指定的有效位数                                 |

##### 数字型转换

1. 在算术函数和表达式中，会自动进行 number 类型转换（==`+` 运算除外。==）。比如，当把除法 `/` 用于非 number 类型：`alert( "6" / "2" );`

2. `Number(value)`、`+value` 显式转换，甚至`Number()`可以将日期转换为时间戳数字。

   <img src="http://humoon-image-hosting-service.oss-cn-beijing.aliyuncs.com/img/typora/数字类型的转换规则.png" alt="数字类型的转换规则" style="zoom: 67%;" />

3. `parseInt(value, 10)`从字符串中“读取”表示数字的字符，直到无法读取为止，然后按第二个参数表示的进制解析这部分字符，返回解析结果。`parseFloat(value)`没有第二个参数，只解析10进制浮点数。由于`Number()`的规则比较复杂，所以建议使用`parseInt(value, 10)`和`parseFloat(value)`.

   ```java
   alert( parseInt('100px') ); // 100
   alert( parseFloat('12.5em') ); // 12.5
   
   alert( parseInt('12.3$') ); // 12，只有整数部分被返回了
   alert( parseFloat('12.3.4') ); // 12.3，在第二个点出停止了读取
   ```

4. 进行数字类型转换时，两端会被忽略的空白符号包括 `\t`、`\n` 以及“常规”的空格 。
5. `isNaN(x) `，判断参数x==经过数字类型转换后==，是否是NaN
   1. 当参数为纯粹的若干个空白字符时，去掉所有空白后字符串由null被转换成0，于是isNaN会返回 false
   2. 如果需求是检查非数字类型的参数（比如需要将用户输入的字符串转换为数字），isNaN()能够识别出大多数非法字符串，但识别不出纯粹的空白符，反而会误以为用户输入了0。这时就不能用这个函数了，而要用正则表达式。

```javascript
//识别成功
isNaN("a") // true
isNaN(5) // false
isNaN("5") // false
isNaN("  5  ") // false

//识别失败
isNaN("   ") //false

//纯空白必须要被识别出来
isNaN("   ")||"   ".replace(/(^\s*)|(\s*$)/g,"")=="" //true
```

##### 布尔型转换

1. 转换场合
   1. ==逻辑运算时自动转换==
   2. `Boolean(value)` 和`!!`（连续两个取非）显式转换
2. 转换规则
   1. 直观上为“空”的值（如 `0`、`NaN`、空字符串`""`、`null`和`undefined`）将变为 `false`。
   2. 其他值（包括字符串`"0"`、`" "`）一律变成 `true`。

##### 数组与集合互相转换

`new Set()`和`Array.from()`

```javascript
// 数组转集合
var arr = [55, 44, 65];
var set = new Set(arr);
console.log(set.size === arr.length); //true
console.log(set.has(65)); // true
 
// 集合转数组
var set = new Set([1, 2, 3, 3, 4]);
arr2 = Array.from(set);
arr2; //[1,2,3,4]
```

### 基础运算符

#### 二元运算符

1. 四则运算`+ - * /`，取余 `%`，幂运算 `**`
2. 二元运算符 `+` 连接的两个运算元，只要有一个是字符串，另一个也会被转化为字符串（其他算数运算符相反，自动转化为 number 类型），而后通过 `+` 被拼接起来。一个比较复杂的例子：

```javascript
alert(2 + 2 + '1' ); // "41"，不是 "221"
```

3. ==原地修改==：合并了其他操作的赋值运算符 `+=`、`-=`、`*=`、`/=`和`%=`

#### 一元运算符

1. 自增 `++` 将变量与 1 相加，自减 `--` 将变量与 1 相减。
2. 自增/自减只能应用于变量，将其应用于数值会报错。
3. `++` 和 `--` 可以置于变量前，也可以置于变量后。==前置形式返回运算后新的值，后置返回做加法/减法之前的值==。

#### 位运算符

底层操作会用到，应用层很少用。

| 位运算符 | 描述     |
| -------- | -------- |
| `&`      | 与       |
| `|`      | 或       |
| `~`      | 按位求反 |
| `^`      | 异或     |
| `<<`     | 左移     |
| `>>`     | 右移     |

#### 赋值运算符

`=` 在完成赋值操作后，返回 `=` 左边的运算元，如 `let c = 3 - (a = b + 1);`

##### 解构赋值

同时对一组变量进行赋值。

1. 变量数组

```javascript
'use strict'; // 如果浏览器支持解构赋值就不会报错: 

let [x, [y, z]] = ['hello', ['JavaScript', 'ES6']];
x; // 'hello'
y; // 'JavaScript'
z; // 'ES6'

let [, , z] = ['hello', 'JavaScript', 'ES6']; // 忽略前两个元素，只对z赋值第三个元素
z; // 'ES6'

[x, y] = [y, x] //不需要临时变量，完成值的互换
```

2. 批量提取对象的属性

```javascript
// 如果需要从一个对象中取出若干属性，也可以使用解构赋值，便于快速获取对象的指定属性：
let person = {
    name: '小明',
    age: 20,
    gender: 'male',
    passport: 'G-12345678',
    school: 'No.4 middle school',
    address: {
        city: 'Beijing',
        street: 'No.1 Road',
        zipcode: '100001'
    }
};
let {name, address: {city, zip}} = person; // 注意是大括号，而不像变量赋值那样是中括号
```

![解构赋值1](http://humoon-image-hosting-service.oss-cn-beijing.aliyuncs.com/img/typora/JavaScript/解构赋值1.png)

```javascript
name; // '小明'
city; // 'Beijing'
zip; // undefined, person中没有zip属性，所以zip被声明了但没有取到值
zipcode; // Uncaught ReferenceError: zipcode is not defined 直接报错了，全局环境中zipcode甚至没有被声明
address; // Uncaught ReferenceError: address is not defined 同样，address并不是一个被声明的变量
// 其实从Chrome Console中的颜色就能看出来哪些是变量，哪些不是


let {name, address: {city, zipcode: zip}} = person;
```

![解构赋值2](http://humoon-image-hosting-service.oss-cn-beijing.aliyuncs.com/img/typora/JavaScript/解构赋值2.png)

```javascript
// 同样能从颜色看出来，只有name, city, zip是变量
zip; //'100001'
zipcode; // Uncaught ReferenceError: zipcode is not defined


// 解构赋值还可以使用默认值，这样就避免了不存在的属性返回undefined的问题
let person = {
    name: '小明',
    age: 20,
    gender: 'male',
    passport: 'G-12345678'
};
let {name, single=true} = person; // 如果person对象没有single属性，赋值为默认值true
name; // '小明'
single; // true
```

有些时候，如果变量已经被声明了，再次赋值的时候，正确的写法也会报语法错误：

```javascript
let x, y; // 声明变量
{x, y} = { name: '小明', x: 100, y: 200}; // 解构赋值，从右边的对象中提取两个属性
// 语法错误: Uncaught SyntaxError: Unexpected token =

//这是因为JavaScript引擎把`{`开头的语句当作了块处理
//块之间的=是不合法的。解决方法是用小括号括起来，就能把{x, y}解析为对象了
({x, y} = { name: '小明', x: 100, y: 200});

// 另一种解决办法
let {x, y} = { name: '小明', x: 100, y: 200}; 
```

3. 使用场景：解构赋值在很多时候可以大大简化代码。

```javascript
// 快速获取当前页面的域名和路径：
let {hostname:domain, pathname:path} = location;
```

如果==一个函数接收一个对象作为参数==，那么，可以使用解构直接把对象的属性绑定到变量中。

```javascript
// 下面的函数可以快速创建一个Date对象：
function buildDate({ year, month, day, hour = 0, minute = 0, second = 0 }) {
  return new Date(year + '-' + month + '-' + day + ' ' + hour + ':' + minute + ':' + second);
}

// 它的方便之处在于传入的对象只需要`year`、`month`和`day`这三个属性：
buildDate({ year: 2017, month: 1, day: 1 });
// Sun Jan 01 2017 00:00:00 GMT+0800 (CST)

// 也可以传入`hour`、`minute`和`second`属性：
buildDate({ year: 2017, month: 1, day: 1, hour: 20, minute: 15 });
// Sun Jan 01 2017 20:15:00 GMT+0800 (CST)
```



### 关系运算符

1. `==`和`!=`都把数据类型转换为数字后再比较；

2. `===`和`!==`为严格比较运算符，不进行数据类型的转换，可以降低编程犯错的发生几率。由于JS的设计缺陷，推荐使用`===`和`!==`，既检查类型又检查值。

   ```javascript
   alert( null === undefined ); // false
   alert( null == undefined ); // true
   ```

   1. 计算错误`NaN`这个特殊的 number 与所有其他值都不相等，包括它自己：

      ```javascript
      NaN === NaN;  // false
      ```

      唯一能判断`NaN`的方法是通过`isNaN()`函数：

      ```javascript
      isNaN(NaN); // true
      ```

3. 在使用`>=`、`>`、`<`、`<=`进行比较时，需要注意变量可能为 `null/undefined` 的情况。`null` 会被转化为 `0`，`undefined` 会被转化为 `NaN`。（但是在`==`和`!=`检查中， `null/undefined` 的数据类型不会被转换！）所以，比较好的方法是单独检查变量是否等于 `null/undefined`。

4. 浮点数在运算过程中会产生误差，因为计算机无法精确表示无限循环小数。要比较两个浮点数是否相等，只能计算它们之差的绝对值，看是否小于某个阈值：

   ```javascript
   1 / 3 === (1 - 2 / 3); // false
   Math.abs(1 / 3 - (1 - 2 / 3)) < 0.0000001; // true
   ```

### 逻辑运算符

#### 与`&&` 或`||` 非`!`

优先级：`!`>`&&`>`||`

#### 短路逻辑

1. 一个或运算 `||` 的链，将返回第一个经布尔转换后值为TRUE的运算元的==初始值（而非TRUE）==，如果一直不存在，就返回==该链的最后一个运算元的初始值（而非FALSE）==。即`||` 链对参数进行处理，直到达到第一个真值，然后立即返回该值，而无需处理其他参数。

```javascript
//选择有数据的那一个，并显示出来（如果都没有设置，则显示 "Anonymous"）
let firstName = ""; 
let lastName = ""; 
let nickName = "SuperCoder"; 
alert( firstName || lastName || nickName || "Anonymous"); 

true || alert("not printed"); //运算符 || 在遇到 true 时立即停止运算，所以 alert 没有运行。
false || alert("printed"); 
```

2. 一个与运算 `&&` 的链，返回第一个经布尔转换后值为FALSE的运算元的初始值（简称其为假值），如果没有假值，就返回该链的最后一个运算元的初始值。

#### 空值合并运算符

空值合并运算符（nullish coalescing operator）`??`：获得两者中的第一个“已定义的”的值

`a ?? b` 的结果是：

- 如果 `a` 是已定义的（不是`null`或`undefined`），则结果为 `a`，
- 如果 `a` 不是已定义的，则结果为 `b`。

通常 `??` 的使用场景是，为可能是未定义的变量提供一个默认值。例如，如果 `user` 是未定义的，我们则显示 `Anonymous`：

```javascript
let user;
alert(user ?? "Anonymous"); // Anonymous
```



```javascript
let user = "John";
alert(user ?? "Anonymous"); // John
```



```javascript
let firstName = null;
let lastName = 0;
let nickName = "Supercoder";


// 显示第一个已定义的值：
alert(firstName ?? lastName ?? nickName ?? "Anonymous"); // 0
alert(firstName || lastName || nickName || "Anonymous"); // Supercoder
// ?? 是最近才被添加到 JavaScript 中的，它的出现是因为人们对 || 不太满意。
// || 无法区分 false、0、空字符串 "" 和 null/undefined——它们都是假值（falsy values）
```

### 分支结构

#### `if`, `else`, `else if`

```javascript
let age = 3;

if (age >= 18) {
    alert('adult');
} else if (age >= 6) {
    alert('teenager');
} else {
    alert('kid');
}
```

#### `switch()`, `case`, `break`

多用于等值判断的情形。`switch`匹配中的相等是严格相等`===`，被比较的值必须是相同的类型才能进行匹配。

与其他语言不同，JavaScript 中 case 不仅可以是整数，还可以是字符串乃至表达式。

#### 三元运算符`?`

语法为`condition ? value1 : value2;`

```javascript
// 递归 recursion 
function pow(x, n) {
  return (n == 1) ? x : (x * pow(x, n - 1));
}
```

### 循环结构

#### `for()`

```javascript
let x = 0;
let i;
for (i=1; i<=100; i++) {
    x = x + i;
}
x; // 5050
```

`for`循环最常用的地方是利用索引来遍历数组：

```javascript
let arr = ['Apple', 'Google', 'Microsoft'];
let i, x;
for (i=0; i<arr.length; i++) {
    x = arr[i];
    console.log(x);
}
```

`for`循环的3个条件都是可以省略的，如果没有退出循环的判断条件，就必须使用`break`语句退出循环，否则就是死循环：

```javascript
let x = 0;
for (;;) { // 将无限循环下去
    if (x > 100) break; // 通过if判断来退出循环
    x ++;
}
```

#### `for(...in...)`

`for`循环的一个变体，它遍历的是一个对象所有==可枚举==成员的key，==包括继承来的成员==。

```javascript
let person = {
    name: 'Jack',
    age: 20,
    city: 'Beijing'
};

for (let key in person) {
    console.log(key); // 'name', 'age', 'city'
}
```

要过滤掉对象继承的属性，用`obj.hasOwnProperty(key)`来实现：

```javascript
let person = {
    name: 'Jack',
    age: 20,
    city: 'Beijing'
};

for (let key in person) {
    if (person.hasOwnProperty(key)) {
        console.log(key); // 'name', 'age', 'city'
    }
}
```

==`for ... in`循环可以直接循环出`Array`的索引==：

```javascript
let a = ['A', 'B', 'C'];
for (let i in a) {
    console.log(i); // '0', '1', '2'
    // 注意，for ... in对Array的循环，i 是 String 而非 Number！
    console.log(a[i]); // 'A', 'B', 'C'
}

let arr = ['Bart', 'Lisa', 'Adam'];
for (let i in arr) {
    console.log(`Hello, ${arr[i]}!`)
}
```

#### `for(...of...)`

字符串、`Array`、`Map`、`Set`、DOM collection、generator 等类型的对象属于可迭代（iterable）对象，可以通过新的`for ... of`循环来遍历。一般的对象 is not iterable，不能用 for of 遍历，而只能用 for in 遍历。

```javascript
let a = ['A', 'B', 'C'];
let s = new Set(['A', 'B', 'C']);
let m = new Map([[1, 'x'], [2, 'y'], [3, 'z']]);
for (let x of a) { // 遍历Array
    console.log(x);
}
for (let x of s) { // 遍历Set
    console.log(x);
}
for (let x of m) { // 遍历Map
    console.log(x[1] + '=' + x[0]);
}
```



`for ... in`循环由于历史遗留问题，它遍历的实际上是对象成员的所有 key。一个`Array`数组也是一个对象，它的每个元素作为对象的成员，key就是序数索引。但当我们手动给`Array`对象添加了额外的属性后，`for ... in`循环除遍历序数索引外，还将遍历到我们添加的新属性。`for ... of`循环则从底层机制上修复了这些问题，它只循环集合本身的==元素==。

```javascript
let a = ['A', 'B', 'C'];
a.name = 'Hello'; // 手动添加了新的成员（键值对）
for (let x of a) {
    console.log(x); // 'A', 'B', 'C'  不会遍历到name属性
}
```

#### `while()/do...while()`

通常使用 `while(true)` 来构造“无限”循环。这样的循环和其他循环一样，都可以通过 `break` 指令来终止。

如果我们不想在当前迭代中做任何事，并且想要转移至下一次迭代，那么可以使用 `continue` 指令。

`break/continue` 只能跳出一层循环，若要跳出多层的==嵌套==循环，必须使用标签。标签是 `break/continue` 跳出==嵌套==循环以转到外部的唯一方法。

```javascript
let n = 100;

nextPrime: for (let i = 2; i <= n; i++) { //定义标签 nextPrime
    for (let j = 2; j <= i ** (0.5); j++) {
        if (i % j === 0) continue nextPrime; // 不是素数，则继续检查下一个
    }
    console.log(i);
}
```

#### `.forEach()`

可迭代对象的`.forEach(callBack)`方法（这是一个高阶函数）也能遍历：它接收一个回调函数，每次迭代就自动调用该函数，无需返回值。

```javascript
let a = ['A', 'B', 'C'];
a.forEach(function (element, index, array) { // 自定义函数
    // element: 指向当前元素的值
    // index: 指向当前索引
    // array: 指向Array对象本身
    console.log(element + ', index = ' + index);
});
a.forEach(function (element) { //如果不需要，后两个参数可以忽略
    console.log(element);
});

let s = new Set(['A', 'B', 'C']);
s.forEach(function (element, sameElement, set) {
    console.log(element);
});

let m = new Map([[1, 'x'], [2, 'y'], [3, 'z']]);
m.forEach(function (value, key, map) {
    console.log(value);
});
```



## 代码质量

### 严格模式

将 `"use strict";` 写在 .js 脚本的最顶部（只有注释可以出现在 `"use strict";` 的上面。）可以启用现代模式，实现 js 的最新特性。

- 不可使用未声明的变量和对象，这会令浏览器报错。
- 不允许删除变量、对象和函数。
- 不允许使用八进制。
- 禁止this关键字指向全局对象。如使用构造函数时忘了加 new，this 不像非严格模式那样指向全局对象，而是报错。





### 代码风格

<img src="http://humoon-image-hosting-service.oss-cn-beijing.aliyuncs.com/img/typora/JavaScript/代码风格.png" alt="代码风格" style="zoom: 67%;" />

#### 花括号

对于很短的代码，写成一行是可以接受的：例如 `if (cond) return null`。但是`{}`代码块通常更具可读性。

#### 空行

即使是单个函数通常也被分割为数个逻辑块。在下面的示例中，初始化的变量、主循环结构和返回值都被垂直分割了：

```javascript
function pow(x, n) {
  let result = 1;
  //              <--
  for (let i = 0; i < n; i++) {
    result *= x;
  }
  //              <--
  return result;
}
```

插入一个额外的空行有助于使代码更具可读性。写代码时，不应该出现连续超过 9 行都没有被垂直分割的代码。

#### 避免嵌套层级过深

下面的两个结构是相同的。

```javascript
function pow(x, n) {
  if (n < 0) {
    alert("Negative 'n' not supported");
  } else {
    let result = 1;
    for (let i = 0; i < n; i++) result *= x;
    return result;
  }
}
```



```javascript
function pow(x, n) {
  if (n < 0) {
    alert("Negative 'n' not supported");
    return;
  }

  let result = 1;
  for (let i = 0; i < n; i++) result *= x;
  return result;
}
```

但是第二个更具可读性，因为 `n < 0` 这个“特殊情况”在一开始就被处理了。一旦条件通过检查，代码执行就可以进入到“主”代码流，而不需要额外的嵌套。

```javascript
for (let i = 0; i < 10; i++) {
  if (cond) {
    ... // <- 又一层嵌套
  }
}

// 同样，第二种写法利用 continue 减少了层级，可读性更强
for (let i = 0; i < 10; i++) {
  if (!cond) continue;
  ...  // <- 没有额外的嵌套
}
```

#### 函数的位置：先调用后实现

对于“辅助”函数，最好==先写调用代码，再写函数实现==。这是因为阅读代码时，我们首先想要知道的是“它做了什么”，而不是如何实现。==甚至很多时候，我们都不需要阅读这些函数的实现，尤其是它们的名字清晰地展示出了它们的功能的时候==。

为了实现这一原则，要多声明函数（编译时被自动提升至块首），少写函数表达式。

```javascript
// 程序主流程调用函数的代码
let elem = createElement();
setHandler(elem);
walkAround();


// --- 辅助函数 ---
function createElement() {
  ...
}

function setHandler(elem) {
  ...
}

function walkAround() {
  ...
}
```



#### 自动检查器

检查器（Linters）在进行代码风格检查时，还可以发现一些代码错误，例如变量或函数名中的错别字。

要使用 ESLint 需要：

1. 安装 [Node.JS](https://nodejs.org/)。
2. 使用 `npm install -g eslint` 命令安装 ESLint。
3. 在 JavaScript 项目的根目录（包含该项目的所有文件的那个文件夹）创建一个名为 `.eslintrc` 的配置文件，在其中自定义想要实现的代码风格。
4. 在集成了 ESLint 的代码编辑器中安装/启用插件。

```json
{
  "extends": "eslint:recommended",
  "env": {
    "browser": true,
    "node": true,
    "es6": true
  },
  "rules": {
    "no-console": 0,
    "indent": 2
  }
}
```



### 注释

注释不应表达做了什么，那是程序本身应该自我阐明 (self-illuminating) 的东西。注释应该专注于：

#### 程序架构

对组件进行高层次的整体概括，它们如何相互作用、各种情况下的控制流程是什么样的……简而言之 —— ==代码的鸟瞰图==。

有一个专门用于构建代码的高层次架构图，以对代码进行解释的特殊语言 [UML](http://wikipedia.org/wiki/Unified_Modeling_Language)。绝对值得学习。

#### 函数的参数和用法

有一个专门用于记录函数的语法 [JSDoc](http://en.wikipedia.org/wiki/JSDoc)：用法、参数和返回值。这种注释可以帮助我们理解函数的目的，并且不需要研究其内部的实现代码，就可以直接正确地使用它。例如：

```javascript
/*
 * 返回 x 的 n 次幂的值。
 *
 * @param {number} x 要改变的值。
 * @param {number} n 幂数，必须是一个自然数。
 * @return {number} x 的 n 次幂的值。
 */
function pow(x, n) {
  ...
}
```

#### 解决方案的选择原因

解决方案的注释对于日后的理解和维护非常重要。

#### “巧妙”的代码

如果代码存在任何==巧妙但不显而易见==的写法，那绝对需要注释。

#### 注释的自动提取

注释也被用于一些如 JSDoc3 等文档自动生成工具：它们读取注释然后生成 HTML 文档（或者其他格式的文档）。


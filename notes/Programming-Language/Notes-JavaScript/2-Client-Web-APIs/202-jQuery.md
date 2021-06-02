[TOC]

# jQuery

## 简介

jQuery的优点：

- 消除浏览器差异：你不需要自己写冗长的代码来针对不同的浏览器来绑定事件，编写AJAX等代码；
- 简洁的操作DOM的方法：写`$('#test')`肯定比`document.getElementById('test')`来得简洁；
- 轻松实现动画、修改CSS等各种操作。

使用jQuery只需要在页面的`<head>`引入jQuery文件即可：[jQuery官网](https://jquery.com/download/)

```html
<html>
<head>
    <script src="//code.jquery.com/jquery-3.5.1.min.js"></script>
	...
</head>
<body>
    ...
</body>
</html>
```

jQuery把所有功能全部封装在一个全局变量`jQuery`中，而`$`也是一个合法的变量名，它是变量`jQuery`的别名：

```javascript
window.jQuery; // jQuery(selector, context)
window.$; // jQuery(selector, context)
$ === jQuery; // true
typeof($); // 'function'
```

jQuery中的基本对象是==jQuery对象==，JavaScript原生函数生成的DOM对象可以通过`$()`转换为jQuery对象。



## 基本语法

`$(selector).action()`

## 查找节点

### 选择器

#### 元素选择器

按tag查找只需要写上tag名称就可以了：

```javascript
var ps = $('p'); // 返回所有<p>节点
ps.length; // 数一数页面有多少个<p>节点
```

#### id选择器 `#`

如果某个DOM节点有`id`属性，利用jQuery查找如下：

```javascript
// 查找<div id="abc">:
var div = $('#abc'); //返回jQuery对象。jQuery对象类似数组，它的每个元素都是一个引用了DOM节点的对。
```

以上面的查找为例，如果`id`为`abc`的`<div>`存在，返回的jQuery对象如下：`[<div id="abc">...</div>]`

如果`id`为`abc`的`<div>`不存在，返回的jQuery对象如下：`[]`

总之jQuery的选择器不会返回`undefined`或者`null`，这样的好处是你不必在下一行判断`if (div === undefined)`。

jQuery对象和DOM对象之间可以互相转化，通过`.get()`和`$()`

```javascript
var div = $('#abc'); // jQuery对象
var divDom = div.get(0); // 假设存在div，.get()获取第1个DOM元素，返回DOM对象
var another = $(divDom); // $()重新把DOM包装为jQuery对象
```

通常情况下你不需要获取DOM对象，直接使用jQuery对象更加方便。==如果你拿到了一个DOM对象，那可以简单地调用`$(aDomObject)`把它变成jQuery对象，这样就可以方便地使用jQuery的API了==。

#### 类选择器 `.`

按class查找注意在class名称前加一个`.`：

```javascript
var a = $('.red'); // 所有节点包含`class="red"`都将返回
// 例如:
// <div class="red">...</div>
// <p class="green red">...</p>
```

通常很多节点有多个class，我们==可以查找同时包含`red`和`green`的节点==：

```javascript
var a = $('.red.green'); // 注意没有空格！
// 符合条件的节点：
// <div class="red green">...</div>
// <div class="blue green red">...</div>
```

#### 组合选择器

组合查找就是把上述简单选择器组合起来使用。如果我们查找`$('[name=email]')`，很可能把表单外的`<div name="email">`也找出来，但我们只希望查找`<input>`，就可以这么写：

```javascript
var emailInput = $('input[name=email]'); // 不会找出<div name="email">
```

同样的，根据tag和class来组合查找也很常见：

```javascript
var tr = $('tr.red'); // 找出<tr class="red ...">...</tr>
```

#### 并列选择器 `,`

多项选择器就是把多个选择器用`,`组合起来一块选：

```javascript
$('p,div'); // 把<p>和<div>都选出来
$('p.red, p.green'); // 把<p class="red">和<p class="green">都选出来
```

要注意的是，==选出来的元素是按照它们在HTML中出现的顺序排列的，而且不会有重复元素==。例如，`<p class="red green">`不会被上面的`$('p.red,p.green')`选择两次。





```html
<!-- HTML结构 -->
<div id="test-jquery">
    <p id="para-1" class="color-red">JavaScript</p>
    <p id="para-2" class="color-green">Haskell</p>
    <p class="color-red color-green">Erlang</p>
    <p name="name" class="color-black">Python</p>
    <form class="test-form" target="_blank" action="#0" onsubmit="return false;">
        <legend>注册新用户</legend>
        <fieldset>
            <p><label>名字: <input name="name"></label></p>
            <p><label>邮件: <input name="email"></label></p>
            <p><label>口令: <input name="password" type="password"></label></p>
            <p><button type="submit">注册</button></p>
        </fieldset>
    </form>
</div>
```

```javascript
var selected = null;
selected = $('#para-1');     //仅选择JavaScript
selected = $('.color-red.color-green');  //仅选择Erlang
selected = $('.color-red')  //选择JavaScript和Erlang
selected = $('#test-jquery>p:nth-child(odd)')  //选择JavaScript和Erlang
selected = $('[class^="color-"]');  //选择所有编程语言
selected = $('#test-jquery>p')  //选择所有编程语言
selected = $('input[name=name]');     //选择名字input
selected = $('input[name=name],input[name=email]');  //选择邮件和名字input
```

#### 后代选择器 ` `

如果两个DOM元素具有层级关系，就可以用`$('ancestor descendant')`来选择，层级之间用空格隔开。例如：

```html
<!-- HTML结构 -->
<div class="testing">
    <ul class="lang">
        <li class="lang-javascript">JavaScript</li>
        <li class="lang-python">Python</li>
        <li class="lang-lua">Lua</li>
    </ul>
</div>
```

要选出JavaScript，可以用层级选择器：

```javascript
$('ul.lang li.lang-javascript'); // [<li class="lang-javascript">JavaScript</li>]
$('div.testing li.lang-javascript'); // [<li class="lang-javascript">JavaScript</li>]
$('ul.lang li'); //选择所有的<li>节点
$('form.test p input'); // 多层选择，form表单中被<p>包含的<input>
```

#### 子选择器 `>`

子选择器`$('parent>child')`类似层级选择器，但是限定了层级关系必须是父子关系。

```javascript
$('ul.lang>li.lang-javascript'); // 可以选出[<li class="lang-javascript">JavaScript</li>]
$('div.testing>li.lang-javascript'); // [], 无法选出，因为<div>和<li>不构成父子关系
```

#### 兄弟选择器 `+, ~`

`+`选择其后的第一个兄弟，`~`选择其后的所有兄弟

`$("#my+img")`相当于`$("#my").next("img")`

`$("#my~img")`相当于`$("#my").nextAll("img")`

#### 过滤器 `:`

过滤器一般不单独使用，它通常附加在选择器上，帮助我们更精确地定位元素。

##### 基本过滤器

##### 内容过滤器

##### 可见性过滤器

##### 属性过滤器

一个DOM节点除了`id`和`class`外还可以有很多属性，很多时候按属性查找会非常方便，比如在一个表单中按属性来查找：

```javascript
var email = $('[name=email]'); // 找出<??? name="email">
var passwordInput = $('[type=password]'); // 找出<??? type="password">
var a = $('[items!="A"]'); // 找出item属性不是A的元素
```

当属性的值包含空格等特殊字符时，需要用双引号括起来。

按属性查找还可以使用前缀查找或者后缀查找：

```javascript
var icons = $('[name^=icon]'); // 找出所有name属性值以icon开头的DOM
// 例如: name="icon-1", name="icon-2"
var names = $('[name$=with]'); // 找出所有name属性值以with结尾的DOM
// 例如: name="startswith", name="endswith"
```

这个方法尤其适合通过class属性查找，且不受class包含多个名称的影响：

```javascript
var icons = $('[class^="icon-"]'); // 找出所有class包含至少一个以`icon-`开头的DOM
// 例如: class="icon-clock", class="abc icon-home"
```

##### 子元素过滤器

```javascript
$('ul.lang li'); // 选出JavaScript、Python和Lua 3个<li>节点

$('ul.lang li:first-child'); // 仅选出JavaScript
$('ul.lang li:last-child'); // 仅选出Lua
$('ul.lang li:nth-child(2)'); // 选出第N个元素，N从1开始
$('ul.lang li:nth-child(even)'); // 选出序号为偶数的元素
$('ul.lang li:nth-child(odd)'); // 选出序号为奇数的元素
```

#### 表单相关

针对表单元素，jQuery还有一组特殊的选择器：

- `:input`：可以选择`<input>`，`<textarea>`，`<select>`和`<button>`；
- `:file`：可以选择`<input type="file">`，和`input[type=file]`一样；
- `:checkbox`：可以选择复选框，和`input[type=checkbox]`一样；
- `:radio`：可以选择单选框，和`input[type=radio]`一样；
- `:focus`：可以选择当前输入焦点的元素，例如把光标放到一个`<input>`上，用`$('input:focus')`就可以选出；
- `:checked`：选择当前勾上的单选框和复选框，用这个选择器可以立刻获得用户选择的项目，如`$('input[type=radio]:checked')`；
- `:enabled`：可以选择可以正常输入的`<input>`、`<select>` 等，也就是没有灰掉的输入；
- `:disabled`：和`:enabled`正好相反，选择那些不能输入的。

此外，jQuery还有很多有用的选择器，例如，选出可见的或隐藏的元素：

```javascript
$('div:visible'); // 所有可见的div
$('div:hidden'); // 所有隐藏的div
```

### 链式查找和筛选

jQuery对象的所有方法都返回一个jQuery对象（可能是新的也可能是自身），这样我们可以进行链式调用，非常方便。

####  查找方法

```html
<!-- HTML结构 -->
<ul class="lang">
    <li class="js dy">JavaScript</li>
    <li class="dy">Python</li>
    <li id="swift">Swift</li>
    <li class="dy">Scheme</li>
    <li name="haskell">Haskell</li>
</ul>
```

用`find()`==在子节点中==查找：

```javascript
var ul = $('ul.lang'); // 获得<ul>
var dy = ul.find('.dy'); // 获得JavaScript, Python, Scheme
var swf = ul.find('#swift'); // 获得Swift
var hsk = ul.find('[name=haskell]'); // 获得Haskell
```

从当前节点开始向上查找，使用`parent()`方法：

```javascript
var swf = $('#swift'); // 获得Swift
var parent = swf.parent(); // 获得Swift的上层节点<ul>
var a = swf.parent('.red'); // 获得Swift的上层节点<ul>，同时传入过滤条件。如果ul不符合条件，返回空jQuery对象
```

对于位于同一层级的节点，可以通过`next()`、`nextAll()`、`prev()`、`prevAll()`和`siblings()`方法：

```javascript
var swift = $('#swift');

swift.next(); // Scheme
swift.next('[name=haskell]'); // 空的jQuery对象，因为Swift的下一个元素Scheme不符合条件[name=haskell]

swift.prev(); // Python
swift.prev('.dy'); // Python，因为Python同时符合过滤器条件.dy
```

#### 筛选方法

1. `filter()`

   ```javascript
   var langs = $('ul.lang li'); // 拿到JavaScript, Python, Swift, Scheme和Haskell
   var a = langs.filter('.dy'); // 拿到JavaScript, Python, Scheme
   ```

   或者传入一个函数，要特别注意函数内部的`this`被绑定为DOM对象，不是jQuery对象：

   ```javascript
   var langs = $('ul.lang li'); // 拿到JavaScript, Python, Swift, Scheme和Haskell
   langs.filter(function () {
       return this.innerHTML.indexOf('S') === 0; // 返回S开头的节点
   }); // 拿到Swift, Scheme
   ```

2. `map()`

   把一个jQuery对象包含的若干DOM节点转化为其他对象：

   ```javascript
   var langs = $('ul.lang li'); // 拿到JavaScript, Python, Swift, Scheme和Haskell
   var arr = langs.map(function () {
       return this.innerHTML;
   }).get(); // 用get()拿到包含string的Array：['JavaScript', 'Python', 'Swift', 'Scheme', 'Haskell']
   ```

3. `first()`、`last()`和`slice()`
   若一个jQuery对象包含了不止一个DOM节点，`first()`、`last()`和`slice()`方法可以返回一个新的jQuery对象，把不需要的DOM节点去掉

    ```javascript
    var langs = $('ul.lang li'); // 拿到JavaScript, Python, Swift, Scheme和Haskell
    var js = langs.first(); // JavaScript，相当于$('ul.lang li:first-child')
    var haskell = langs.last(); // Haskell, 相当于$('ul.lang li:last-child')
    var sub = langs.slice(2, 4); // Swift, Scheme, 参数和数组的slice()方法一致
    ```

## 修改节点

### 修改HTML内容或文本内容

==jQuery对象==的`text()`和`html()`方法，无参数为分别获取节点的文本和原始HTML文本，传入参数就变成设置文本

```html
<!-- HTML结构 -->
<ul id="test-ul">
    <li class="js">JavaScript</li>
    <li name="book">Java &amp; JavaScript</li>
</ul>
```

```javascript
// 获取文本
$('#test-ul li[name=book]').text(); // 'Java & JavaScript'
$('#test-ul li[name=book]').html(); // 'Java &amp; JavaScript'

//修改文本
var j1 = $('#test-ul li.js');
var j2 = $('#test-ul li[name=book]');
j1.html('<span style="color: red">JavaScript</span>'); //解析内部的标签，生成新节点
j2.text('JavaScript & ECMAScript'); //text()是纯文本，不会生成新节点
```

jQuery对象可以任意个DOM对象，它的方法实际上会作用在对应的每个DOM节点上。

即使选择器没有选出任何DOM节点，调用jQuery对象的方法仍然不会报错，这意味着jQuery帮你免去了许多`if`语句。

### 修改样式

##### 直接修改CSS属性

`css()`方法将作用于DOM节点的`style`属性，具有最高优先级。

1. 若只接收一个参数，将获取该属性的值


```javascript
  var div = $('#test-div');
  div.css('color'); // '#000033', 获取CSS属性
  div.css('color', '#336699'); // 设置CSS属性
  div.css('color', ''); // 清除CSS属性
```

 为了和JavaScript保持一致，CSS属性可以用`'background-color'`和`'backgroundColor'`两种格式。

1. 当接收到两个参数时，每一个`css('name', 'value')`设置一个CSS属性及其值。

   jQuery对象有“批量操作”的特点，这用于修改CSS实在是太方便了。考虑下面的HTML结构：

   ```html
   <!-- HTML结构 -->
   <ul id="test-css">
       <li class="lang dy"><span>JavaScript</span></li>
       <li class="lang"><span>Java</span></li>
       <li class="lang dy"><span>Python</span></li>
       <li class="lang"><span>Swift</span></li>
       <li class="lang dy"><span>Scheme</span></li>
   </ul>
   ```

   要高亮显示动态语言，我们用一行语句实现：

   ```javascript
   $('#test-css li.dy>span').css('background-color', '#ffd351').css('color', 'red');
   ```


##### 通过修改`class`间接修改样式

`hasClass()`判断该节点的class中是否包含参数

 `addClass()`添加class

 `removeClass()`删除class

```javascript
var div = $('#test-div');
div.hasClass('highlight'); // false， class是否包含highlight
div.addClass('highlight'); // 添加highlight这个class
div.removeClass('highlight'); // 删除highlight这个class
```

### 修改属性

`attr()`和`removeAttr()`

```javascript
// <div id="test-div" name="Test" start="1">...</div>
var div = $('#test-div');
div.attr('data'); // undefined, 属性不存在
div.attr('name'); // 'Test'
div.attr('name', 'Hello'); // div的name属性变为'Hello'
div.removeAttr('name'); // 删除name属性
div.attr('name'); // undefined
```

`prop()`方法和`attr()`类似，但是HTML5规定有一种属性在DOM节点中可以没有值，只有出现与不出现两种，例如：

```html
<input id="test-radio" type="radio" name="test" checked value="1">
```

等价于：

```html
<input id="test-radio" type="radio" name="test" checked="checked" value="1">
```

`attr()`和`prop()`对于属性`checked`处理有所不同：

```javascript
var radio = $('#test-radio');
radio.attr('checked'); // 'checked'
radio.prop('checked'); // true
```

`prop()`返回值更合理一些。不过，用`is()`方法判断更好：

```javascript
var radio = $('#test-radio');
radio.is(':checked'); // true
```

类似的属性还有`selected`，处理时最好用`is(':selected')`。

### 显示和隐藏DOM

```javascript
var a = $('a[target=_blank]');
a.hide(); // 隐藏
a.show(); // 显示
```

隐藏DOM节点并未改变DOM树的结构，它只影响DOM节点的显示。这和删除DOM节点是不同的。

### 获取BOM信息

```javascript
// 浏览器可视窗口大小:
$(window).width(); // 800
$(window).height(); // 600

// HTML文档大小:
$(document).width(); // 800
$(document).height(); // 3500

// 某个div的大小:
var div = $('#test-div');
div.width(); // 600
div.height(); // 300
div.width(400); // 设置CSS属性 width: 400px，是否生效要看CSS是否有效
div.height('200px'); // 设置CSS属性 height: 200px，是否生效要看CSS是否有效
```

### 操作表单 `val()`

对于表单元素，jQuery对象统一提供`val()`方法获取和设置对应的`value`属性：

```javascript
/*
    <input id="test-input" name="email" value="">
    <select id="test-select" name="city">
        <option value="BJ" selected>Beijing</option>
        <option value="SH">Shanghai</option>
        <option value="SZ">Shenzhen</option>
    </select>
    <textarea id="test-textarea">Hello</textarea>
*/
var
    input = $('#test-input'),
    select = $('#test-select'),
    textarea = $('#test-textarea');

input.val(); // 'test'
input.val('abc@example.com'); // 文本框的内容已变为abc@example.com

select.val(); // 'BJ'
select.val('SH'); // 选择框已变为Shanghai

textarea.val(); // 'Hello'
textarea.val('Hi'); // 文本区域已更新为'Hi'
```

## 添加节点

### 创建新元素（新jQuery对象）

```javascript
let $newElement = $("HTML代码片段"); //如果有标签，也要写在字符串中
```

`$newElement` 整体是一个元素，引用时不要漏掉“$”

### 将新元素添加到DOM树中

`append()`添加到父元素的子DOM树最后，`prepend()`添加到父元素的子DOM树最前

同级节点可以用`after()`或者`before()`方法。

例：

```html
<div id="test-div">
    <ul>
        <li><span>JavaScript</span></li>
        <li><span>Python</span></li>
        <li><span>Swift</span></li>
    </ul>
</div>
```

```javascript
var ul = $('#test-div>ul'); //拿到`<ul>`节点：
ul.append('<li><span>Haskell</span></li>'); //调用append()传入HTML片段
```

除了接受字符串，`append()`还可以传入原始的DOM对象，jQuery对象和函数对象：

```javascript
// 创建DOM对象:
var ps = document.createElement('li');
ps.innerHTML = '<span>Pascal</span>';
// 添加DOM对象:
ul.append(ps);

// 添加jQuery对象:
ul.append($('#scheme'));

// 添加函数对象:
ul.append(function (index, html) {
    return '<li><span>Language - ' + index + '</span></li>';
});
```

传入函数时，要求返回一个字符串、DOM对象或者jQuery对象。因为jQuery的`append()`可能作用于一组DOM节点，只有传入函数才能针对每个DOM生成不同的子节点。

另外注意，如果要添加的DOM节点已经存在于HTML文档中，它会首先从文档移除，然后再添加，也就是说，用`append()`，你可以移动一个DOM节点。

如果要把新节点插入到指定位置，例如，JavaScript和Python之间，那么，可以先定位到JavaScript，然后用`after()`方法：

```javascript
var js = $('#test-div>ul>li:first-child');
js.after('<li><span>Lua</span></li>');
```

## 删除节点

`remove()`

如果jQuery对象包含若干DOM节点，实际上可以一次删除多个DOM节点

```javascript
var li = $('#test-div>ul>li');
li.remove(); // 所有<li>全被删除
```

## 事件

因为JavaScript在浏览器中以单线程模式运行，页面加载后，一旦页面上所有的JavaScript代码被执行完后，就只能依赖触发事件来执行JavaScript代码。

浏览器在接收到用户的鼠标或键盘输入后，会自动在对应的DOM节点上触发相应的事件。如果该节点已经绑定了对应的JavaScript处理函数，该函数就会自动调用。

语法：` $("...").bind("事件类型"， function(e){....})`，其中e是事件对象，记录鼠标键盘的各种状态

如： `$("...").bind("click"， function(e){....})`

简写形式 `$("...").click(function(e){....})`

```javascript
$("#btn").click(function(e){
    console.log("hello");
})
```

```html
<!DOCTYPE html>
<html lang="en">

<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <title>Image Gallery</title>
    <script src="//code.jquery.com/jquery-3.5.1.min.js"></script>
    <link rel="stylesheet" href="styles/layout.css" type="text/css" media="screen" />
</head>

<body>
    <h1>Snapshots</h1>
    <ul id="imagegallery">
        <li>
            <a href="images/fireworks.jpg" title="A fireworks display">
                <img src="images/thumbnail_fireworks.jpg" alt="Fireworks" />
            </a>
        </li>
        <li>
            <a href="images/coffee.jpg" title="A cup of black coffee">
                <img src="images/thumbnail_coffee.jpg" alt="Coffee" />
            </a>
        </li>
        <li>
            <a href="images/rose.jpg" title="A red, red rose">
                <img src="images/thumbnail_rose.jpg" alt="Rose" />
            </a>
        </li>
        <li>
            <a href="images/bigben.jpg" title="The famous clock">
                <img src="images/thumbnail_bigben.jpg" alt="Big Ben" />
            </a>
        </li>
    </ul>
    <script>
        //避免新的事件函数覆盖旧的
        let addLoadEvent = function(toAddOnload) {
            if (typeof window.onload != 'function') {
                window.onload = toAddOnload;
            } else {
                let existedOnload = window.onload;
                window.onload = function() {
                    existedOnload();
                    toAddOnload();
                }
            }
        }

        //事件函数：显示大图和说明
        let displayGallery = function() {
            $("#imagegallery").after("<img id = 'placeholder' src ='./images/placeholder.gif' width = '350'>");
            $("#placeholder").after("<p id = 'description'>Choose an image</p>");
            $("li>a").bind("click", function() {
                $("#placeholder").attr("src", $(this).attr("href"));
                $("#description").text($(this).attr("title"));
                return false; //废掉链接的跳转功能
            })
        }

        addLoadEvent(displayGallery);
    </script>
</body>

</html>
```





## 动画

用JavaScript实现动画，原理非常简单：我们只需要以固定的时间间隔（例如，0.1秒），每次把DOM元素的CSS样式修改一点（例如，高宽各增加10%），看起来就像动画了。

但是==要用JavaScript手动实现动画效果，需要编写非常复杂的代码==。如果想要把动画效果用函数封装起来便于复用，那考虑的事情就更多了。

使用jQuery实现动画，代码已经简单得不能再简化了：只需要一行代码！




[TOC]

## 事件

https://zh.javascript.info/events

事件可以是浏览器行为，也可以是用户行为。如：HTML 页面完成加载，HTML input 字段改变，HTML 按钮被点击。

### 添加事件的两种方法

#### 为 HTML 元素添加事件属性

形如：`<HTML-element event='JavaScript 语句或函数'>`

这种方法简便，但 HTML 和 JavaScript 内容没有完全分开，耦合性较强。

```html
<button onclick="displayDate()">点这里</button>
<script>
function displayDate(){
	document.getElementById("demo").innerHTML = Date();
}
</script>
<p id="demo"></p>
```

#### 完全用 JavaScript 向 HTML 元素绑定事件

这种方法实现了 HTML、CSS、JS 之间的低耦合，便于程序扩展和分享。

```html
<button id="myBtn">点这里</button>
<script>
document.getElementById("myBtn").onclick = () => {
    document.getElementById("demo").innerHTML = Date();
};
</script>
<p id="demo"></p>
```

### 常用事件

- onchange: HTML元素改变，常结合对输入字段的验证来使用。

```html
输入你的名字: <input type="text" id="fname" onchange="myFunction()">
<p>当你离开输入框后，函数将被触发，将小写字母转为大写字母。</p>
<script>
function myFunction(){
	var x=document.getElementById("fname");
	x.value=x.value.toUpperCase();
}
</script>
```

- ==onload：页面或图片加载完成时==。
- onunload：用户离开页面时。onload 和 onunload 事件可用于处理 cookie。

```html
<body onload="checkCookies()">

<script>
function checkCookies(){
    alert("消息在 onload 事件触发后弹出。");
    
	if (navigator.cookieEnabled==true){
		alert("Cookies 可用")
	}
	else{
		alert("Cookies 不可用")
	}
}
</script>
<p>弹窗-提示浏览器 cookie 是否可用。</p>
	
</body>
```

- onmousedown：点击鼠标按钮时
- onmouseup: 释放鼠标按钮时
- onmousemove：鼠标光标移动。
- ==onmouseout：鼠标光标从某元素移开。==
- ==onmouseover：鼠标光标移到某元素上。==
- ==onclick：完成鼠标点击时。==键盘tab选中DOM某元素后，按下回车并松开，也会触发！

```html
<h1 onmouseover="this.style.color='red'"onmouseout="this.style.color='black'">将鼠标移至文本上</h1>

<div onmouseover="mOver(this)" onmouseout="mOut(this)" style="background-color:#D94A38;width:120px;height:20px;padding:40px;">Mouse Over Me</div>
<script>
function mOver(obj){
	obj.innerHTML="Thank You"
}
function mOut(obj){
	obj.innerHTML="Mouse Over Me"
}
</script>
```

```html
<!--两张图片切换实现动画效果-->
<img id="myimage" onmousedown="lighton()" onmouseup="lightoff()" src="灯灭.gif" width="100" height="180" />
<p>点击不释放鼠标灯将一直亮着!</p>
<script>
function lighton(){
	document.getElementById('myimage').src="灯亮.gif";
}
function lightoff(){
	document.getElementById('myimage').src="灯灭.gif";
}
</script>
```

- ondblclick：鼠标双击。
- onfocus：元素获得焦点
- onblur：元素失去焦点
- onselect：文本被选定
- onkeydown：键盘某个按键按下。
- onkeypress：键盘回车按下并松开。
- onkeyup：键盘某个按键松开。如一个input输入框，在键盘按键离开的一刹那开始执行动作（如读取框中的内容）。

### .addEventListener() 

`.addEventListener(event, function, useCapture)`方法用于向指定元素添加事件句柄。

`.removeEventListener(event, function)`移除事件的监听

- 第一个参数是事件的类型 (如 "click" 或 "mousedown"). ==注意：不要使用 "on" 前缀==。 例如，使用 "click" ,而不是使用 "onclick"。
- 第二个参数是事件触发后调用的函数。
- 第三个参数是个布尔值用于描述事件是冒泡(false)还是捕获(true)。该参数是可选的。
  - 在冒泡中，内部元素的事件会先被触发，然后再触发外部元素的事件。
  - 在捕获中，外部元素的事件会先被触发，然后才会触发内部元素的事件

```html
<p>实例演示了在添加不同事件监听时，冒泡与捕获的不同。</p>
<div id="myDiv">
	<p id="myP">点击段落，我是冒泡。</p>
</div><br>
<div id="myDiv2">
	<p id="myP2">点击段落，我是捕获。 </p>
</div>
<script>
document.getElementById("myP").addEventListener("click", () => {
    alert("你点击了 P 元素!");
}, false);
document.getElementById("myDiv").addEventListener("click", () => {
    alert(" 你点击了 DIV 元素 !");
}, false);
document.getElementById("myP2").addEventListener("click", () => {
    alert("你点击了 P2 元素!");
}, true);
document.getElementById("myDiv2").addEventListener("click", () => {
    alert("你点击了 DIV2 元素 !");
}, true);
```



addEventListener() 方法添加的事件句柄不会覆盖已存在的事件句柄。

可以向一个元素添加多个事件句柄。

可以向同个元素添加多个同类型的事件句柄，如：两个 "click" 事件。

```html
    <button id="myBtn">点我</button>
    <p id="demo"></p>
    <script>
        let x = document.getElementById("myBtn");
        x.addEventListener("mouseover", () => {
            document.getElementById("demo").innerHTML += "Moused over!<br>"
        });
        x.addEventListener("click", () => {
            document.getElementById("demo").innerHTML += "Clicked!<br>"
        });
        x.addEventListener("mouseout", () => {
            document.getElementById("demo").innerHTML += "Moused out!<br>"
        });
    </script>
```



你可以向任何==DOM 对象==添加事件监听，不仅仅是 HTML 元素，还可以监听 ==BOM 对象==。

```html
<p>实例在 window 对象中使用 addEventListener() 方法。</p>
<p>尝试重置浏览器的窗口触发 "resize" 事件句柄。</p>
<p id="demo"></p>
<script>
window.addEventListener("resize", function(){
    document.getElementById("demo").innerHTML = Math.random();
});
</script>
```

### 所有事件列表

https://www.runoob.com/jsref/dom-obj-event.html



### 模拟事件

JavaScript 可以模拟一切事件，比如用来测试。


[TOC]

<p align = center>表1 Web 前端三大技术</p>

|技术|功能|
|:----:|:----:|
|HTML|网页的结构|
|CSS|网页的样式|
|JavaScript|网页的行为|



# HTML

## VSCode自动扩展

1. 双屏可以同时观看 HTML 代码和 CSS 代码
2. 用 vscode 插件即时渲染 HTML 代码
3. 单击行号折叠成对标签之间的代码
4. ==`Ctrl`+`D`选择一个单词；`Ctrl`+`L`选择一行==
5. 新建一个 HTML 文件，输入`!`后回车或按`Tab`键即可自动扩展为标准 HTML5 框架
6. `Ctrl`+`/`添加注释或把某一行代码变为注释
7. 输入`CSS选择器`后按回车可自动扩展为对应的标签
   1. `标签名#id属性值`后按回车可自动扩展为带有 id 属性的标签
   2. `标签名.class属性值`后按回车可自动扩展为带有 class 属性的标签
   3. `标签名#id属性值.class属性值`后按回车可自动扩展为带有 id 和 class 属性的标签
   4. 输入`标签名[属性名=属性值]`后按回车可自动扩展为包含内容、属性和值的标签
   5. 输入`标签名>标签名`后按回车可自动扩展为嵌套的起止标签
   6. 输入`标签名+标签名`后按回车可自动扩展为同级的起止标签
8. 输入`标签名{内容}`后按回车可自动扩展为包含内容的起止标签
9. 用`()`表达标签的分组。如`(div>p)+(div>img)`扩展后形如
```html
<div>
    <p></p>
</div>
<div><img src="" alt=""></div>
```
13. 输入`标签名*n`后按回车可自动扩展为重复 n 次的起止标签。如`ol>li*3>ol>li*2`扩展后形如


```html
    <ol>
        <li>
            <ol>
                <li></li>
                <li></li>
            </ol>
        </li>
        <li>
            <ol>
                <li></li>
                <li></li>
            </ol>
        </li>
        <li>
            <ol>
                <li></li>
                <li></li>
            </ol>
        </li>
    </ol>
```
填写内容后渲染得到：
<ol>
        <li>是什么
            <ol>
                <li>观察</li>
                <li>调研</li>
            </ol>
        </li>
        <li>为什么
            <ol>
                <li>建模</li>
                <li>检验</li>
            </ol>
        </li>
        <li>怎么办
            <ol>
                <li>宣传</li>
                <li>行动</li>
            </ol>
        </li>
    </ol>

14. 输入`table>caption+(tr>th*3)+tr*4>td*3`后按回车可自动扩展为 5 行 3 列带表标题的表格
15. 在`<head>`下输入`link:css`后按回车可自动扩展为链接 css 文件的 link 标签
19. 快速输入 css 属性：
    1. 前提：在 css 定义区内部
    2. `w`+`数字`后按回车可自动扩展为`width: 数字px;`，同理有`h`（height）、`mg`（margin）、`pd`（padding）、`lh`+`数字em`（line-height）、`bgc`（background-color）

## HTML 的基本概念

1. 标签
2. 元素（标签与内容的组合）
3. 属性（描述标签），值
   1. 例：`<img src='plot.png' alt='未显示图片'/>`
4. Web 语义化：设计一些与自然语言贴近的标签，便于人和搜索引擎的理解，以及网页与多种设备的兼容

## HTML 标签实例

### 特殊字符

`&实体名称;`，如`&nbsp;`为空格

```html
<!DOCTYPE html>
<html>

<head>
  <meta charset="UTF-8">
  <title>特殊标记的使用</title>
</head>

<body>
  在HTML中，常用的特殊字符有：<br />
  &lt;、&gt;、&amp;、&quot;、&copy;、&reg;、&trade;、&times;、&divide;等。

</body>

</html>
```

<img src="https://i.loli.net/2021/03/06/LIb81vfksVuxrpC.png" alt="image-20210306160156065" style="zoom:50%;" />

### 表格

```html
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>表格基本结构</title>
</head>
<body>
<table border="2" width="300">
	<caption>教师信息表</caption>
	<thead>
		<tr>
			<th>工号</th>
			<th>姓名</th>
			<th>性别</th>
		</tr>
	</thead>
	<tfoot>
		<tr>
			<td colspan="3" align="center">这里是表尾</td>
		</tr>
	</tfoot>
	<tbody>
		<tr>
			<td>8888</td>
			<td>刘艺丹</td>
			<td>女</td>
		</tr>
	</tbody>
</table>

</body>
</html>
```

### 表单

```html
<!doctype html>
<html>

<head>
  <meta charset="utf-8">
  <title>表单综合实例</title>
</head>

<body>
  <table align="center" width="500" border="0" cellpadding="2" cellspacing="0">
    <caption align="center">
      <h2>学生注册信息</h2>
    </caption>
    <form action="server.php" method="post">
      <tr>
        <th>姓名：</th>
        <td><input type="text" name="username" size="20" /></td>
      </tr>
      <tr>
        <!-- 使用单选按钮域定义性别输入框 -->
        <th>性别：</th>
        <td>
          <input type="radio" name="sex" value="1" checked="checked" />男
          <input type="radio" name="sex" value="2" />女
          <input type="radio" name="sex" value="3" />保密
        </td>
      </tr>
      <tr>
        <!--  使用下拉列表域定义学历输入框  -->
        <th>学历：</th>
        <td>
          <select name="edu">
            <option>--请选择--</option>
            <option value="1">高中</option>
            <option value="2">大专</option>
            <option value="3">本科</option>
            <option value="4">研究生</option>
            <option value="5">其他</option>
          </select>
        </td>
      </tr>
      <tr>
        <!-- 使用复选框按钮域定义选修课程输入框 -->
        <th>选修课程：</th>
        <td>
          <input type="checkbox" name="course[]" value="4">Linux
          <input type="checkbox" name="course[]" value="5">Apache
          <input type="checkbox" name="course[]" value="6">Mysql
          <input type="checkbox" name="course[]" value="7">PHP
        </td>
      </tr>
      <tr>
        <!-- 使用多行输入框定义自我[评价输入框 -->
        <th>自我评价：</th>
        <td><textarea name="eval" rows="4" cols="40"></textarea></td>
      </tr>
      <tr>
        <!--  定义提交和重置两个按钮-->
        <td colspan="2" align="center">
          <input type="submit" name="submit" value="提交">
          <input type="reset" name="reset" value="重置">
        </td>
      </tr>
    </form>
  </table>
</body>

</html>
```



# CSS

## 基本概念

1. cascading style sheets，层叠样式表，内容和样式可分离，便于修改样式。
2. CSS语法
   1. `Selector {property1:value1; property2:value2; ...}`
   2. 选择器：决定对哪些 html 元素起作用——标签与该选择器同名的元素可以应用该选择器定义的样式
   3. 属性、值
   4. 注释`/* */`

## CSS 添加方法

1. 行内：要定义样式的标签内部加一个`style="property1:value1; property2:value2; ..."`属性，精确控制单个元素
2. 内嵌：将 CSS 代码内嵌到==`<head>`标签下==的`<style type='text/css'></style>`标签中，只能控制一个 html 文档
3. 外部 .css 文件

   1. 链接：在 html 文件的`<head>`标签下添加包含`href`属性的`link`标签，便于用==一个 css 文件控制很多 html 文件==的风格。语法格式为：`<link type="text/css" rel="stylesheet" href="css文件的url">`
   2. 导入：用 @import 导入。语法格式为：`<style type="text/css"> @import url("css文件的url"); </style>`或`<style type="text/css"> @import "css文件的url"; </style>`，且必须放在其他 css 之前
4. 三种添加方式的 css 代码相互冲突时，优先级为：
   1. 行内样式>内嵌样式>链接样式>浏览器默认样式
   2. id选择器>class选择器>元素选择器

## CSS 选择器

### 属性选择器

CSS新定义的选择器，共七种：

```css
/* 对有class属性的div元素起作用的CSS样式 */
div[class] {
  background-color: #aaa;
}

/* 对class属性值等于xx的div元素起作用的CSS样式 */
/* 元素只能有一个class属性，且为xx */
div[class="xx"] {
  background-color: #111;
  color: #fff;
}

/* 一个元素可能有好几个class属性，但其中一个必须是xx */
div[class~="xx"] {
  background-color: #111;
  color: #fff;
}

/* 元素只能有一个class属性，且等于xx或以"xx-"开头 */
div[class|="xx"] {
  background-color: #111;
  color: #fff;
}

/* class属性的值中包含xx字符串 */
div[class*="xx"] {
  background-color: #999;
}

/* class属性不管有几个值，第一个值必须以xx开头 */
div[class^="xx"] {
  background-color: #555;
  color: #fff;
}

/* class属性不管有几个值，最后一个值必须以xx结尾 */
div[class$="xx"] {
  background-color: #111;
  color: #fff;
}
```

示例：

```html
<!DOCTYPE html>
<html>
<head>
	<meta name="author" content="Yeeku.H.Lee(CrazyIt.org)" />
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title> 属性选择器 </title>
	<style type="text/css">
	/* 对所有div元素都起作用的CSS样式 */
	div {
		width:300px;
		height:30px;
		background-color:#eee;
		border:1px solid black;
		padding:10px;
	}
	/* 对有id属性的div元素起作用的CSS样式 */
	div[id] {
		background-color:#aaa;
	}
	/* 对有id属性值包含xx的div元素起作用的CSS样式 */
	div[id*="xx"] {
		background-color:#999;
	}
	/* 对有id属性值以xx开头的div元素起作用的CSS样式 */
	div[id^="xx"] {
		background-color:#555;
		color:#fff;
	}
	/* 对有id属性值等于xx的div元素起作用的CSS样式 */
	div[id="xx"] {
		background-color:#111;
		color:#fff;
	}
	</style>
</head>
<body>
<div>没有任何属性的div元素</div>
<div id="a">带id属性的div元素</div>
<div id="zzxx">id属性值包含xx子字符串的div元素</div>
<div id="xxyy">id属性值以xx开头的div元素</div>
<div id="xx">id属性值为xx的div元素</div>
</body>
</html>
```

### 选择器的混合使用原则

1. 继承（inheritance），若无特别声明，子元素将继承父元素的样式属性
2. 叠加：多个 css 样式定义可对同一个元素起作用时，最终显示将是多个样式定义叠加的效果
3. 一个元素标签中的 class 属性可以用空格隔开，取多个值，从而同时应用相应的多个选择器定义的样式

### 伪元素选择器

并无对应的真实DOM元素，实际展示的是一种行为。

#### 插入选择器

##### 语法

`:before`，对指定对象内部的前端插入内容；`:after`，对指定对象内部的末端插入内容

##### 配合属性

与插入选择器配合使用的描述插入内容的属性：
1. content：该属性的值可以是字符串、url(url)[^pic]、attr(alt)、counter(name)、counter(name,list-style-type)、open-quote、close-quote等格式。该属性用于指定插入内容。
2. quotes：该属性用于为content属性定义open-quote和close-quote（插入内容的前后缀），该属性的值可以是两个以空格分隔的字符串，其中前面的字符串是open-quote，后面的字符串是close-quote。
3. counter-increment：该属性用于定义一个计数器。该属性的值就是所定义的计数器的名称。
4. counter-reset：该属性用于对指定的计数值复位。
5. 其中，content属性是核心，counter-increment、counter-reset都需要和content结合使用。

##### 应用场景

1. 插入图像，通过 `content:url("");`
2. 插入前后缀，通过`{quotes:"" "";}`定义和`:before{content:open-quote;}`、`:after{content: close-quote;}`的使用。

[^pic]:通过此方式可以插入图片。

```html
<!DOCTYPE html>
<html>
<head>
	<meta name="author" content="Yeeku.H.Lee(CrazyIt.org)" />
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title> 添加符号 </title>
	<style type="text/css">
		/* 定义open-quote为<<，close-quote为>> */
		div>div{
			quotes: "<<" ">>";
		}
		/* 指定为div的子div的前端插入open-quote */
		div>div:before{
			content: open-quote;
		}
		/* 指定为div的子div的尾端插入close-quote */
		div>div:after{
			content: close-quote;
		}
	</style>
</head>
<body>
	<div>
	<div>疯狂Java讲义</div>
	<div>疯狂Android讲义</div>
	<div>轻量级Java EE企业应用实战</div>
	</div>
</body>
</html>
```

3. 添加自定义编号：通过`counter-increment: mycounter;`定义计数器，然后通过`content:counter(mycounter, list-style-type) `引用计数器即可。

```html
<!DOCTYPE html>
<html>
<head>
	<meta name="author" content="Yeeku.H.Lee(CrazyIt.org)" />
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title> 添加编号 </title>
	<style type="text/css">
		/* 为div的子div元素定义了一个计数器：mycounter */
		div>div{
			counter-increment: mycounter;
		}
		/* 在div的子div元素的前端插入mycounter计数器和一个点  */
		div>div:before{
			content: '第'counter(mycounter, cjk-ideographic)'.';
			font-size: 20pt;
			font-weight: bold;
		}
	</style>
</head>
<body>
	<div>
	<div>疯狂Java讲义</div>
	<div>疯狂Android讲义</div>
	<div>轻量级Java EE企业应用实战</div>
	</div>
</body>
</html>
```

4. 添加多级编号：注意用`counter-reset: ;`重置下一级别的编号，再次从 1 开始。

```html
<!DOCTYPE html>
<html>

<head>
    <meta name="author" content="Yeeku.H.Lee(CrazyIt.org)" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title> 多级编号 </title>
    <style type="text/css">
        h2 {
            counter-increment: chapter;
            counter-reset: section;
        }
        
        h3 {
            counter-increment: section;
        }
        
        h2:before {
            content: '第'counter(chapter, cjk-ideographic)'章 ';
        }
        
        h3:before {
            content: '§'counter(section)' ';
        }
    </style>
</head>

<body>
    <h1>hhh</h1>
    <h2>疯狂Java体系图书</h2>
    <h3>lsfjal</h3>
    <h3>afdafaf</h3>
    <div>疯狂Java讲义</div>
    <div>疯狂Android讲义</div>
    <div>轻量级Java EE企业应用实战</div>
    <h2>其他图书</h2>
    <h3>adf</h3>
    <h3>sfaf</h3>
    <div>Struts 2.1权威指南</div>
    <div>JavaScript权威指南</div>
</body>

</html>
```

### 在脚本中修改显示样式

需要 js 代码来驱动


## 属性和值

### 单位

| 单位 | 描述                                 |
| ---- | ------------------------------------ |
| px   | 像素                                 |
| em   | 字体尺寸单位，自动适应用户使用的字体 |
| %    | 百分比，相对于默认大小               |

### 颜色

| 颜色                 | 描述                                                    |
| -------------------- | ------------------------------------------------------- |
| 英文名，如 red, blue | https://www.w3school.com.cn/cssref/css_colors_legal.asp |
| rgb(x, x, x)         | RGB 值                                                  |
| rgb(x%, x%, x%)      | RGB 百分比值                                            |
| rgba(x, x, x, x)     | RGB 值+透明度                                           |
| rrggbb               | 红色：#ff0000                                           |

### 列表实例

```css
ul,
ol {
    margin: 0 0 1.5em 0.5em;
}

p+ul,
p+ol {
    /* ul 和 ol 是 p 的下一个兄弟节点 */
    margin-top: 0.5em;
}

h3+ul,
h4+ul,
h5+ul,
h6+ul,
h3+ol,
h4+ol,
h5+ol,
h6+ol {
    margin-top: 0.5em;
}

li>ul,
li>ol {
    margin-top: inherit;
    margin-bottom: 0;
    margin-left: 0.5em;
}

li ul>li {
    list-style-type: circle;
}

ol>li {
    list-style-type: cjk-ideographic;
}

li ol>li {
    list-style-type: decimal;
}

li li ol>li {
    list-style-type: upper-alpha;
}

li li li ol>li {
    list-style-type: lower-greek;
}
```

### 章节标题实例

```css
h2 {
    counter-increment: chapter;
    counter-reset: section;
}

h3 {
    counter-increment: section;
}

h2:before {
    content: '第'counter(chapter, cjk-ideographic)'章 ';
}

h3:before {
    content: '§'counter(section)' ';
}
```

### 三线表格实例

```css
table {
    border-collapse: collapse;
    border-spacing: 0;
    margin-bottom: 1.5em;
    font-size: 1em;
}

tr:nth-child(even) {
    background: #e8e7e7;
}

thead th,
tfoot th {
    padding: .25em .25em .25em .4em;
    text-transform: uppercase;
}

table>caption {
    margin-bottom: 0.5em;
    font-size: 120%;
    font-family: KaiTi;
}

th {
    text-align: center;
}

td {
    vertical-align: middle;
    padding: .25em .25em .25em .4em;
}


/* 三线表 */

table>thead>tr>th {
    /* thead 表示表格的页眉 */
    border-top: 2px solid #000;
    border-bottom: 1px solid #000;
}

table>tbody>tr>th {
    border-top: 2px solid #000;
    border-bottom: 1px solid #000;
}

table>tbody>tr:last-child {
    /* tbody 表示表格的主体 */
    border-bottom: 2px solid #000;
}
```

## 布局和定位

### 盒子模型

![boxModelImg](https://i.loli.net/2021/03/08/lUQd9zaCNqYgA1F.jpg)

1. 由内到外的层级：内容 content, 内边距 padding, 边框 border, 外边距 margin
2. overflow 属性：当盒子的内容溢出盒子的边界时

   1. ‘hidden’，超出部分不可见
   2. ‘scroll’，显示滚动条
   3. ‘auto’，如果有超出部分，显示滚动条
   4. visible, 若内容溢出，浏览器会在内容区域之外显示完整的子矩形对象。
4. padding 和 margin
   1. 为了便于自己设定布局，首先要对默认值清零。`*{padding: 0; margin: 0;}`
   2. 它们的取值可以是 px 或 %（最外层盒子长宽的百分比）
   3. padding 和 margin 可以与 ==top, right, bottom, left 组合（注意默认顺序）==，形成 2 个属性和 8 个子属性，共 10 种属性。如`margin: 1px 2px 1px 3px;`，若省略后两个数值，则默认与前两个值的设定对称。
   4. margin 在垂直方向上会以外边距中最大的值作为两个盒子上下边框之间的距离，而在水平方向上以两个外边距的值相加作为两个盒子左右边框之间的距离
   5. div ==区域在盒子中的水平居中==可以通过设定==margin-left 和 margin-right 的值为 auto==来实现。
5. 盒子尺寸计算方式
   1. `box-sizing: content-box|border-box|inherit;` 
   2. border-box，设置的width和height是盒子宽高，减去padding和margin得到实际内容的宽高；
   3. content-box，设置的width和height本身就是内容宽高，盒子的宽高更大一些。

### 定位机制

1. 文档流 flow（默认）
   1. 从上到下从左到右依次排列，不预先固定元素的位置
   2. 元素分类：
      1. block 类型元素，从上到下，独占一行，如`<div>`、`<p>`、`<h1>`、`<ul>`、`<ol>`、`<li>`、`<table>`、`<form>` 
      2. inline 类型元素，不可设置 width、height、margin、padding 等属性，屏幕宽度够用时，会共用一行，不会自动换行，如`<span>`、`<a>`。两个 inline 元素水平排列时默认会有一定的间隙，如果想进行调整，处理起来比较麻烦。此时往往将其转换成 inline-block 类型元素再排版。
      3. inline-block 类型元素，不独占一行，且 width、height、margin、padding 等属性都可以设置，如`<img>`。两个 inline-block 元素水平排列时也默认会有一定的间隙（margin 外边界之间！），需要将它们所在大盒子的 font-size 设定为 0，才能使这个间隙消失。
   3. 元素类型转换：CSS 中的 display 属性
      1. none，元素不会被显示，==也不占用页面空间，相当于不存在==
      2. `a{display: block;}`，显示为 block 类型，让每个超链接独占一行
      3. 可以显示为 inline 类型，显示为行内元素
      4. `a{display: inline-block;}`，使超链接的高和宽可以设置。详见课程官方代码。
   4. visibility 属性
      1. visible，可见
      2. hidden，不可见，但==仍占用原有的页面空间、影响页面布局==，相当于透明度为0
2. 浮动定位 float
   1. 由于 div 元素默认单独占据一行，因此要进行水平向几大块的排版时，要使用浮动定位
   2. CSS中任何元素都可以浮动，且浮动元素会生成一个块级框，无论它原来是什么元素
   3. float 属性的值 left，right 和 none，分别代表向左、右侧浮动和不浮动
   4. clear 属性清除浮动：both，不允许左右任何一侧出现浮动元素，若违反则换新行显示；left 或 right，清除一边的浮动，即这一边不能有其他浮动元素，若违反则换新行显示
3. 层定位 layer
   1. position 属性：设定相对于那个参照物
      1. static，文档流定位，设定的相对位置无效，z-index 也无效。即仍在 body 所在的层中，完全没有成为新的层。
      2. fixed，相对于浏览器窗口定位，坐标原点是屏幕的左上角。常见于广告栏
      3. absolute，相对于 static 定位以外的第一个父元素定位；若其父元素都是 static 定位，就相对于 body 进行定位。该元素脱离正常的文档流，成为单独的一层，body 层上就像它不存在以后其他元素重新排版一样
      4. relative，该元素保持在正常的文档流中，相对于它本来应该出现的位置（即 left、right、top、bottom均为 0 时的情况）进行重新定位。它虽然相对于它本来应该出现的位置移动了，但它在文档流中的原位置不会被其他元素占据
      5. 常用：图片相对定位，仍在文档流中，使图片与其对应文字的相对位置不变；图片中的描述文字作为图片区域的子元素，绝对定位，保持与图片的相对位置不变。
   2. 存在多个层时，z-index 属性值越大越在表层，此属性仅当 position 属性值为 relative 和 absolute 时有效

### 常用布局

1. header
2. banner
3. nav
4. sidebar
5. main
6. footer

## CSS3 动画

1. 过渡：`transition: property duration function delay;`
2. 变形：`transform: none|transform-functions;`








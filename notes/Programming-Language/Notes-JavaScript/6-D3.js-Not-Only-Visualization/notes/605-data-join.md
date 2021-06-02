[TOC]

## 05 数据与 DOM 元素的绑定

### 选集（selection）及其操作

`d3.select()`和`d3.selectAll()`返回的对象称为选集（selection），是 D3 生成的特殊对象，可以操作 DOM。

#### 选集的链式语法

```javascript
let allCirclesInGroups = d3.selectAll("g circle")
```

尽管可以如上所示把相邻的 select() 和 selectAll() 语句的参数串在一起写成一行(“g circle”)，但这种 CSS 选择器式的写法并不太常见。更常见且更有用的做法是==按顺序修改相关的元素，先从 DOM 树里层级最高的元素开始，再一步步选择更具体的元素==：

```javascript
d3.select("svg").attr("width", 500).attr("height", 300)
    .selectAll("circle").attr("cx", 250).attr("cy", 150)
    .selectAll("title").text("Circles rock!")
```

#### 将选集赋值给变量

代码更清晰，复用程度更高。

#### 查看选集状态

`selection.empty()` 判断选集是否为空

`selection.node()` 返回第一个非空元素

`selection.size()` 返回选集中的元素个数

#### 设置属性

- `selection.attr()`
  - `selection.attr(name[, value])`获取/设定 HTML 属性为统一值
  - `selection.attr(name, (d[, i]) => {})` 绑定数据后可以根据数据的值设置属性
- `selection.classed(name[, true/false])`包含第二个参数时，可以快速添加/删除类属性；省略第二个参数时，返回布尔值，判断标签是否包含 name 这个类属性
- `selection.style(name[, value[, priority]])`获取/设定样式。
  - style优先级高于attr。
  - 可以用对象的形式将几个样式写在一起：

```javascript
selection.style({"color":"red","font-size":"30px"});
```

- `selection.property(name[, value])`获取/设定选集的属性（尤其是无法用attr()获取的属性，如文本输入框、复选框的 value 属性）。

```html
<input id="fname" type="text" name="fullname"/>
<script>
    d3.select("#fname").property("value", "Lisi");
    // 不论用户输入了何值，js都会将该值改为Lisi
</script>
```

- `selection.text([value])`获取/设定文本内容，相当于 DOM 的 innerText，不包含其中的标签。

- `selection.html([value])`获取/设定 selection 的内部 HTML 内容，相当于 DOM 的 innerHTML，包括元素内部的标签。

#### 添加、插入和删除元素

`selection.append()`在选集末尾添加元素

`selection.insert(name[, before])`再选集指定元素之前插入元素，name 是新插入元素的名称，before 是 CSS 选择器的名称

`selection.remove()`删除元素。==调试时，`selection.attr("opacity", "0")`可以起到和remove相似的效果，还不会彻底删除元素。== 

### 数据绑定（data-join）

#### `datum`和`data()`

1. `selection.datum([value])`选集中的每一个元素绑定相同的 value，若无参数，则返回元素的 value. 即使 value 是一个数组，selection 的每一个元素都会绑定这个数组，而不会绑定其元素。
2. `selection.data([Array[, keyFunction]])`选集中的每一个元素按照 key 键函数设定的对应关系分别绑定==数组==Array中的每一项。
   1. ==默认的绑定是按照索引顺序==，即第一个数据值绑定到选集的第一个 DOM 元素，第二个数据值绑定到选集的第二个 DOM 元素，以此类推。
   2. 如果数据值与 DOM 元素的顺序不一样，就要==定义键函数（key function）来指定配对的规则==

3. 绑定数据后，节点对象将拥有一个`__data__`属性，其中保存着被绑定的数据。

```javascript
let dataset = [5, 10, 15, 20, 25];

d3.select("body")
    .selectAll("p") //若无这一行，则为绑定数据到body节点，然后.enter()返回指针到body节点的父节点（html节点），然后添加的p会与body节点平级，即在body节点之外
    .data(dataset) //绑定数据至所有的 p 节点
    .enter() //.enter()返回指针到p节点的父节点（body节点）
    .append("p") //在body节点末尾创建新的p节点
    .text(d => "I can count up to " + d) 
    .style("color", d => { return d > 15 ? "red" : "black"; });
```

4. 在被绑定数据的 selection 中添加子元素后，新的子元素会继承该数据，即子元素的`__data__`属性中也将保存着数据。



`selection.join()`: https://github.com/d3/d3-selection/blob/v2.0.0/README.md#selection_join

会根据数据的条目补全or删除图元

```js
svg.selectAll("circle").data(data)
  .join("circle")
    .attr("fill", "none")
    .attr("stroke", "black");
```

等价于

```js
svg.selectAll("circle").data(data)
  .join(
    enter => enter.append("circle"),
    update => update,
    exit => exit.remove()
  )
    .attr("fill", "none")
    .attr("stroke", "black");
```

可以分别指定

```js
svg.selectAll("circle")
  .data(data)
  .join(
    enter => enter.append("circle").attr("fill", "green"),
    update => update.attr("fill", "blue")
  )
    .attr("stroke", "black");
```

还可以在 `.join()`内部用`.call()`执行动画：

The selections returned by the *enter* and *update* functions are merged and then returned by *selection*.join.

You also animate enter, update and exit by creating transitions inside the *enter*, *update* and *exit* functions. To avoid breaking the method chain, use *selection*.call to create transitions, or return an undefined enter or update selection to prevent merging: the return value of the *enter* and *update* functions specifies the two selections to merge and return by *selection*.join.

For more, see the [*selection*.join notebook](https://observablehq.com/@d3/selection-join).

#### 数据更新

`selection.data(newdata, key).enter()`指向新数据比旧数据（保存于既有的dom元素中。）多出来的子集，可称之为加入集。这是纯数据的集合，不含 DOM 元素。（若是第一次绑定数据，则既有的DOM中一个数都没有，绑定的数据集全部都是加入集，必须append()才能真正绑定元素。）

`selection.data(newdata, key).exit()`指向旧数据比新数据多出来的部分，可称之为退出集。其中有即将退出的 DOM 元素。

`selection.data(newdata, key)`返回一个对象，其中不仅包含旧数据和新数据中都存在的元素（可以称之为更新集），还有`enter()`和`exit()`两个 function，调用时可以返回加入集和退出集。

当希望图形随数据的更新而更新时，我们需==要分别给这三个选集合适的处理方法==。一般来说，update 选集要更新属性，==enter 选集要 append() 元素，exit 选集要删除元素==。

data()、enter()、exit() 这些==选集操作只是数学上的集合操作，append()这一步才是真正地与DOM元素绑定==。写代码时，`select().data().enter()`都可以写在一行，因为只是数学操作，DOM没有变化；而`.append()`要另起一行，因为DOM变化了！

`加入选集.merge(更新选集)`可以把加入选集和更新选集合并起来，共同执行某些操作。

以下是一个更新模板，易读性和可维护性都很好：

```javascript
let rect = svg.selectAll("rect"); //其他元素替换rect也一样

// data-join
let update = rect.data(dataset);
let enter = update.enter();
let exit = update.exit();

// update selection
update.attr();

// enter selection
enter.append("rect").attr(); // enter 选集若不 append() 就没有元素与之对应

// exit selection
exit.remove();
```

<img src="http://humoon-image-hosting-service.oss-cn-beijing.aliyuncs.com/img/typora/JavaScript/data_enter_exit.gif" alt="data_enter_exit" style="zoom:50%;" />

```html
<body>
  <p class="p1">点击观察<strong>更新</strong>选集的变化</p>
  <p class="p2">点击观察<strong>加入</strong>选集的变化</p>
  <p class="p3">点击观察<strong>退出</strong>选集的变化</p>
  <p class="p4">复位</p>
  <script>
    let width = 900, height = 400;

    //Data
    let old_data = [
      { name: "1", value: 5 },
      { name: "2", value: 10 },
      { name: "3", value: 15 },
      { name: "4", value: 20 },
      { name: "5", value: 25 }
    ];
    let new_data = [
      { name: "3", value: 17 },
      { name: "4", value: 22 },
      { name: "5", value: 27 },
      { name: "6", value: 35 },
      { name: "7", value: 40 }
    ];

    var svg = d3.select("body")
      .append("svg").attr("width", width).attr("height", height)

    svg.selectAll("circle").data(old_data).enter()
      .append("circle")
      .attr("cx", d => (+d.name * 100) - 25) 
      .attr("cy", height / 5)
      .attr("r", d => d.value)
      .attr("fill", "darkblue");

    let update_circle = svg.selectAll('circle').data(new_data, d => d.name);
    let enter_circle = update_circle.enter().append('circle');
    let exit_circle = update_circle.exit()

    //On click, update with new data
    d3.select("p.p1")
      .on("click", function () {
        update_circle
          .attr("cy", 2 * height / 5)
          .attr("r", d => d.value)
          .attr("fill", "darkgreen");
      });

    d3.select("p.p2")
      .on("click", function () {
        enter_circle
          .attr("cx", d => (+d.name * 100) - 25) 
          .attr("cy", 3 * height / 5)
          .attr("r", d => d.value)
          .attr("fill", "darkgreen");
      });

    d3.select("p.p3")
      .on("click", function () {
        exit_circle
          .attr("cy", 4 * height / 5)
          .attr("r", d => d.value)
          .attr("fill", "darkgreen");
      });

    d3.select("p.p4")
      .on("click", function () {

        svg.selectAll("circle").remove();

        svg.selectAll("circle").data(old_data).enter()
          .append("circle")
          .attr("cx", d => (+d.name * 100) - 25)
          .attr("cy", height / 5)
          .attr("r", d => d.value)
          .attr("fill", "darkblue");

        update_circle = svg.selectAll('circle').data(new_data, d => d.name);
        enter_circle = update_circle.enter().append('circle');
        exit_circle = update_circle.exit()

      });

  </script>
</body>
```

#### 过滤器

`filter(f)`根据匿名回调函数 f 作用于数据，根据返回的 T/F 过滤选集

```javascript
.filter(d => d > 15).style("color", "red") // 只对通过筛选的元素进行操作
```

1. 滑块组件和过滤器

```html
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="utf-8">
  <title>滑块组件</title>
  <!-- 本地D3 -->
  <!-- <script src="./js/d3.js"></script> -->
  <script src="https://d3js.org/d3.v4.min.js"></script>
  <!-- 本地jQuery -->
  <!-- <script src="./js/jquery-3.5.1.min.js"></script> -->
  <!-- 微软CDN上的jQuery -->
  <!-- <script src="https://ajax.aspnetcdn.com/ajax/jquery/jquery-3.5.1.min.js"></script> -->
  <!-- 百度CDN上的jQuery -->
  <script src="https://apps.bdimg.com/libs/jquery/2.1.4/jquery.min.js"></script>
  <link rel="stylesheet" href="./css/index.css" />
  <style type="text/css">
    p {
      display: inline-block;
    }

    input {
      height: 250px;
      width: 30px;

      /* Orient vertically */
      -webkit-appearance: slider-vertical;
      writing-mode: bt-lr;
    }
  </style>
</head>

<body>

  <p>
    <!-- 滑块组件 -->
    <input id="slider" type="range" min="0" max="25" step="1" value="0" orient="vertical">
  </p>

  <script type="text/javascript">

    //Width and height
    var w = 600;
    var h = 250;

    var dataset = [{ key: 0, value: 5 },		//dataset is now an array of objects.
    { key: 1, value: 10 },		//Each object has a 'key' and a 'value'.
    { key: 2, value: 13 },
    { key: 3, value: 19 },
    { key: 4, value: 21 },
    { key: 5, value: 25 },
    { key: 6, value: 22 },
    { key: 7, value: 18 },
    { key: 8, value: 15 },
    { key: 9, value: 13 },
    { key: 10, value: 11 },
    { key: 11, value: 12 },
    { key: 12, value: 15 },
    { key: 13, value: 20 },
    { key: 14, value: 18 },
    { key: 15, value: 17 },
    { key: 16, value: 16 },
    { key: 17, value: 18 },
    { key: 18, value: 23 },
    { key: 19, value: 25 }];

    var xScale = d3.scaleBand()
      .domain(d3.range(dataset.length))
      .rangeRound([0, w])
      .paddingInner(0.05);

    var yScale = d3.scaleLinear()
      .domain([0, d3.max(dataset, function (d) { return d.value; })])
      .range([0, h]);

    //Define key function, to be used when binding data
    var key = function (d) {
      return d.key;
    };

    //Create SVG element
    var svg = d3.select("body")
      .append("svg")
      .attr("width", w)
      .attr("height", h);

    //Create bars
    svg.selectAll("rect")
      .data(dataset, key)
      .enter()
      .append("rect")
      .attr("x", function (d, i) {
        return xScale(i);
      })
      .attr("y", function (d) {
        return h - yScale(d.value);
      })
      .attr("width", xScale.bandwidth())
      .attr("height", function (d) {
        return yScale(d.value);
      })
      .attr("fill", function (d) {
        return "rgb(0, 0, " + (d.value * 10) + ")";
      });

    //Create labels
    svg.selectAll("text")
      .data(dataset, key)
      .enter()
      .append("text")
      .text(function (d) {
        return d.value;
      })
      .attr("text-anchor", "middle")
      .attr("x", function (d, i) {
        return xScale(i) + xScale.bandwidth() / 2;
      })
      .attr("y", function (d) {
        return h - yScale(d.value) + 14;
      })
      .attr("font-family", "sans-serif")
      .attr("font-size", "11px")
      .attr("fill", "white");



    //On change, update styling
    d3.select("input")
      .on("change", function () { //用 change 事件监听滑块组件的变化

        var threshold = +d3.select(this).node().value; //拖动或释放滑块时，change 事件就会触发。这一行取到滑块的当前值

        svg.selectAll("rect")
          .attr("fill", function (d) {
            return "rgb(0, 0, " + (d.value * 10) + ")";
          })
          .filter(function (d) {
            return d.value <= threshold;
          })
          .attr("fill", "red");

      });

  </script>
</body>

</html>
```

#### 排序

`selection.sort(f = d3.ascending)`重新排列选集中的元素，回调函数 f 也被称为比较器。如果不指定比较器，默认为 d3.ascending（升序排列）

[selection.order](https://github.com/mbostock/d3/wiki/Selections#wiki-order) - 对文档中的元素重排序以匹配选择集。

#### 遍历

`selection.each()`为==选集中的每个元素==执行任意函数

#### 传递

`selection.call(f)`允许==将选集 selection 自身作为参数，传递给匿名函数 f==.

为 chart 添加拖拽、缩放等交互项时，常常用到`selection.call(f)`


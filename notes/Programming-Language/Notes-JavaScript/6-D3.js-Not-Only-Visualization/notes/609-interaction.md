## 10 交互

`selection.on("eventName", "callBack")`

为选集的元素针对事件添加监听器。

事件监听器也是匿名函数，可以监听（一个或多个）特定元素上发生的事件，可以使用`this`访问元素。

### 事件类型

#### 左键单击 click

在 HTML 的 body 中添加一个 p 标签：

```html
<p>Click on this text to update the chart with new data values (once).</p>
```

然后在D3代码中添加：

```javascript
    //On click, update with new data			
    d3.select("p")
      .on("click", function () {
        //匿名函数，其中的 this 会引用被单击的p元素
         //See which p was clicked
        let paragraphID = d3.select(this).attr("id");

        //Decide what to do next
        if (paragraphID == "add") {
          ...
        } else {
          ...
        }
          
      }
    );
```

#### 悬停 mouseover, mouseout

简单的悬停高亮只用 CSS 就能实现，CSS 的伪类选择符`:hover`可以跟其他选择符组合起来，表示鼠标指针悬停在元素上方的状态。

```css
    /* 告诉各种浏览器，为rect元素的任何变化设置0.25s的过渡效果 */
    rect {
      -moz-transition: all 0.25s;
      -o-transition: all 0.25s;
      -webkit-transition: all 0.25s;
      transition: all 0.25s;
    }

    /* 所有rect元素在鼠标悬停时变为橙色 */
    rect:hover {
      fill: orange;
    }
```

除了CSS，这些过渡也可以通过 JavaScript 和 D3 来进一步控制，而且这样还能与图表的其他部分协同。

`on(“mouseover”, f)`和`on("mouseout",  f)`联用时，与`:hover`等价。

```javascript
      .on("mouseover", function () { //鼠标悬停时 
        d3.select(this)
          .attr("fill", "orange");
      })
      .on("mouseout", function (d) { //鼠标离开时
        d3.select(this).transition().duration(250)
          .attr("fill", "rgb(0, 0, " + (d * 10) + ")");
      });
```

==悬停的动画效果触发得太频繁，可能会打断其他动画==，所以悬停效果最好还是交给 CSS 打理，而那些视觉变化更密集的操作可以交给 D3 和 JavaScript。



#### keydown 

按键

#### 右键单击 contextmenu

回调函数中必须加入这一行：

`d3.event.preventDefault();`

#### 排序

`.sort((a, b)=>{})`，`sort()`的参数是一个匿名比较函数，比较函数不接收 d（当前数据值）或 i（当前索引）作为参数，而是接受另外两个值：a 和 b。这两个值代表来自两个不同元素的数据值。这个比较函数会针对数组中的每一对元素调用一次，比较 a 和 b，直到所有数组元素都按我们指定的规则排序完毕。

```javascript
//Define sort function
    var sortBars = function () {

      svg.selectAll("rect")
        .sort(function (a, b) {
          return d3.ascending(a, b); //升序
        })
        .transition()
        .duration(1000)
        .attr("x", function (d, i) {
          return xScale(i);
        });
    };
```

- [d3.event](https://github.com/mbostock/d3/wiki/Selections#wiki-d3_event) - 获取当前交互的用户事件。

- [d3.mouse](https://github.com/mbostock/d3/wiki/Selections#wiki-d3_mouse) - 获取鼠标的相对某元素的坐标。
- [d3.touches](https://github.com/mbostock/d3/wiki/Selections#wiki-d3_touches) - 获取相对某元素的触控点坐标

### 元素的重叠与分组

在 SVG 中，后加入 DOM 的元素在视觉层次上会被渲染在先加入的元素前面。如果鼠标悬停在元素重叠部分的上方，系统认为只有上方元素会触发监控器。要在某些元素（如值标签）上忽略鼠标事件，只需给这些元素添加一行css代码：`pointer-events: none;`

g元素自身不会触发任何鼠标事件，因为g元素没有像素。绑定在g元素上的事件监听器，会对它内部的所有元素产生效果。==当一组视觉元素需要统一行为时，这种机制相当有用==。

### Tooltip（提示工具）

很多情况下，没有必要在默认的视图中为每个数值都加上标签，但又要确保这个层次的细节让用户有办法看到。此时就需要提示条，当用户针对性地关注某一节点时（如鼠标悬停），弹出提示信息。

#### 浏览器默认提示工具

要实现这样的提示条，只要给那些需要提示条的元素==嵌入一个 title 元素==即可。实现简单，但定制性极差。

![dvw2_1009](http://humoon-image-hosting-service.oss-cn-beijing.aliyuncs.com/img/typora/JavaScript/dvw2_1009.png)

```javascript
svg.selectAll("rect")
      .data(dataset)
      .enter()
      .append("rect")
      .attr(...)
      .append("title")
      .text(function (d) {
        return "This value is " + d;
      });
```

#### SVG 元素提示工具

使用 SVG 元素制作提示条的方案有很多。

1. 添加事件监听器，在每次发生 mouseover 事件时动态创建值标签，在 mouseout 事件发生时将值标签删除。
2. 预先生成所有标签，然后根据鼠标悬停状态切换它们的显示和隐藏属性。
3. 只创建一个标签，然后根据需要显示 / 隐藏并改变其位置。）

```javascript
.on("mouseover", function (d) {
        //Get this bar's x/y values, then augment for the tooltip
        var xPosition = parseFloat(d3.select(this).attr("x")) + xScale.bandwidth() / 2;
        var yPosition = parseFloat(d3.select(this).attr("y")) + 14;

        //Create the tooltip label
        svg.append("text")
          .attr("id", "tooltip")
          .attr("x", xPosition)
          .attr("y", yPosition)
          .attr("text-anchor", "middle")
          .attr("font-family", "sans-serif")
          .attr("font-size", "11px")
          .attr("font-weight", "bold")
          .attr("fill", "black")
          .text(d);
      })
      .on("mouseout", function () {
        //Remove the tooltip
        d3.select("#tooltip").remove();
      })
```

这段代码是按第三种思路写的，鼠标点击哪个元素，就将其背后的数据传给`on()`函数，在`on()`函数内部读取并使用该数据。但有些版本的 d3.js 不允许这种写法。有些版本的 d3.js 中`on()`的第二个参数的匿名函数是无法将数据 (d) 作为参数传入的，只能用`d3.select(this)`获取选定元素的所有属性值，但==没有体现在属性值中的元素内容就无法读取了）==。因此，[chapter_10/06_smoother.html]() 和 [chapter_10/13_svg_tooltip.html]() 的写法可能会无效。

#### HTML 的 div 提示工具

也可以使用 HTML 的 div 元素作为提示条，这适用于如下情形：

- SVG 不可能实现你想要的效果，或者支持不够好（例如 CSS 阴影）
- 提示条要超出 SVG 图形的边界，如下图所示：

![dvw2_1011](http://humoon-image-hosting-service.oss-cn-beijing.aliyuncs.com/img/typora/JavaScript/dvw2_1011.png)

![dvw2_1012](http://humoon-image-hosting-service.oss-cn-beijing.aliyuncs.com/img/typora/JavaScript/dvw2_1012.png)

可以在 HTML 里创建一个隐藏的 div，然后给它填充上数据值，在触发事件时再显示出来。

```html
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="utf-8">
  <title>D3 Page Template</title>
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
    rect:hover {
      fill: orange;
    }

    #tooltip {
      /* absolute确保精确控制其在页面的位置 */
      position: absolute;
      width: 200px;
      height: auto;
      padding: 10px;
      background-color: white;
      /* 圆角 */
      -webkit-border-radius: 10px;
      -moz-border-radius: 10px;
      border-radius: 10px;
      /* 阴影效果 */
      -webkit-box-shadow: 4px 4px 10px rgba(0, 0, 0, 0.4);
      -moz-box-shadow: 4px 4px 10px rgba(0, 0, 0, 0.4);
      box-shadow: 4px 4px 10px rgba(0, 0, 0, 0.4);
      /* 鼠标经过tooltip本身时，即使离开了条形（因tooltip覆盖在条形上方，进入tooltip区域会被判定为离开条形），也不会触发mouseout事件 */
      pointer-events: none;
    }

    /* hidden类的样式已经设定好，在tooltip元素上添加与否无所谓 */
    #tooltip.hidden {
      display: none;
    }

    #tooltip p {
      margin: 0;
      font-family: sans-serif;
      font-size: 16px;
      line-height: 20px;
    }
  </style>
</head>

<body>
  <!-- 提示工具 -->
  <div id="tooltip" class="hidden">
    <p><strong>Important Label Heading</strong></p>
    <p><span id="value">100</span>%</p>
  </div>

  <script type="text/javascript">

    //Width and height
    var w = 600;
    var h = 250;

    var dataset = [5, 10, 13, 19, 21, 25, 22, 18, 15, 13,
      11, 12, 15, 20, 18, 17, 16, 18, 23, 25];

    var xScale = d3.scaleBand()
      .domain(d3.range(dataset.length))
      .rangeRound([0, w])
      .paddingInner(0.05);

    var yScale = d3.scaleLinear()
      .domain([0, d3.max(dataset)])
      .range([0, h]);

    //Create SVG element
    var svg = d3.select("body")
      .append("svg")
      .attr("width", w)
      .attr("height", h);

    //Create bars
    svg.selectAll("rect")
      .data(dataset)
      .enter()
      .append("rect")
      .attr("x", function (d, i) {
        return xScale(i);
      })
      .attr("y", function (d) {
        return h - yScale(d);
      })
      .attr("width", xScale.bandwidth())
      .attr("height", function (d) {
        return yScale(d);
      })
      .attr("fill", function (d) {
        return "rgb(0, 0, " + Math.round(d * 10) + ")";
      })
      .on("mouseover", function (d) {

        //Get this bar's x/y values, then augment for the tooltip
        var xPosition = parseFloat(d3.select(this).attr("x")) + xScale.bandwidth() / 2;
        var yPosition = parseFloat(d3.select(this).attr("y")) / 2 + h / 2;

        //Update the tooltip position and value
        d3.select("#tooltip")
          .style("left", xPosition + "px")
          .style("top", yPosition + "px")
          .select("#value")
          .text(d);

        //删除 hidden 类，Show the tooltip
        d3.select("#tooltip").classed("hidden", false);

      })
      .on("mouseout", () => d3.select("#tooltip").classed("hidden", true))
      //Hide the tooltipfunction

  </script>
</body>

</html>
```

把提示条 div 和 SVG 图表都放到一个包含元素（如一个容器 div）中会好一些，因为这样只要关心相对位置就行了。d3.mouse 可以让你取得鼠标相对于页面上其他任何元素的坐标，对于需要相对鼠标位置定位非 SVG 元素的情况很有用。

### 触摸设备

触摸设备（比如 iOS 和 Android 设备）上的浏览器能够自动将触摸事件转换为鼠标事件，从而方便 JavaScript 编程。触摸某个元素会被浏览器解释为一次 click 事件。

然而，==鼠标悬停事件不会在触摸设备上触发==，所以依赖悬停事件的提示条永远不会出现。

所以，为了跨设备通用，不会频繁发生的事件最好都写成click事件。
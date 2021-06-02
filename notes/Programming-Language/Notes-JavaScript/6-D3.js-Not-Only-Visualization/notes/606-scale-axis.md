[TOC]

## 07 比例尺

比例尺本质上是一种映射，因此必然可以用函数来表现：比例尺是一组把输入定义域映射为输出值域的函数。

坐标轴只是比例尺的一种形象表示。比例尺实际上代表着一种映射关系，没有直接的视觉呈现。

### 线性比例尺

定义域（domain）；值域（range）；标准化（normalization）

`d3.scaleLinear()` 定义线性比例尺，返回其映射函数。`.domain()`, `.range()`常与`d3.max()`, `d3.extent()`等函数连用

```javascript
// 定义比例尺
const scale = d3.scaleLinear()
  .domain([100, 500])
  .range([10, 350]);

// 使用比例尺
console.log(scale(300)); // 180
```

比例尺的几个微调函数：

- `.nice()`，使定义域向两端扩展，直到值域取最接近的比较整数的值。比如，通过定义域的扩展使值域 [0.201479..., 0.996679...] 优化成 [0.2, 1.0]。
- `.rangeRound()`替代`.range()`，比例尺输出的所有值都会舍入到最接近的整数值，这有利于图形的像素更精确，避免边缘出现锯齿。
- `.clamp(true)`，强制所有输出值被舍入到指定的范围内，即使输入值超越了定义域的范围

### 序数比例尺

序数比例尺中最常用的一种：band 比例尺

```javascript
const students = [
  { name: 'Shao-Kui', age: 25, height: 176 },
  { name: 'Wen-Yang', age: 24, height: 180 },
  { name: 'Liang Yuan', age: 29, height: 172 },
  { name: 'Wei-Yu', age: 23, height: 173 }
];

const xScale = d3.scaleBand() //分档比例尺，有序、均匀分布
  .domain(students.map(person => person.name)) // 序数比例尺的定义域，一般是一个包含类别名称的数组。
  .rangeRound([0, innerWidth]) //相比单一功能的range()，rangeRound()可以在分档时四舍五入，防止边界处理半个像素（抗锯齿处理）
  .paddingInner(0.05); //使各个条形之间有一定间距，单位为一档全部宽度的比例，此处为5%
```

由于分档比例尺已经计算好了合适的分档坐标，从而也就计算好了合适的条形宽度，故可以用`分档比例尺.bandwidth()`函数获取条形宽度，不需要再手动计算了。

同理，用`xScale(person.name)`获取各条形端点的x坐标

```javascript
const existedRects = d3.select('body').selectAll('rect');

let updateSet = existedRects.data(students); // 已经与图元绑定的数据
let enterSet = updateSet.enter(); // 多出来未与图元绑定的数据

enterSet.append('rect') // 新建图元
  .attr("width", xScale.bandwidth())
  .attr("x", person => xScale(person.name));
```



### 其他比例尺

- `scaleSqrt()`，平方根比例尺
- `scalePow()`，指数比例尺。比例尺多一个方法`exponent()`指定底数
- `scaleLog()`，对数比例尺，多一个方法`base()`用来指定幂次
- `scaleQuantize()`、`scaleBand()`，定义域连续、值域离散的比例尺，适合数据分类。如热力图，不同数值段使用不同的颜色。

```javascript
    var quantize = d3.scaleQuantize()
      .domain([50, 0])
      .range(["#888", "#666", "#444", "#222", "#000"]);

    var r = [45, 35, 25, 15, 5];

    var svg = d3.select("body").append("svg")
      .attr("width", 400)
      .attr("height", 400);

    svg.selectAll("circle")
      .data(r)
      .enter()
      .append("circle")
      .attr("cx", function (d, i) { return 50 + i * 30; })
      .attr("cy", 50)
      .attr("r", function (d) { return d; })
      .attr("fill", function (d) { return quantize(d); });
```



- `scaleQuantile()`，输入定义域为离散值，适合离散自变量
- `scaleOrdinal()`，使用非定量值（如分类名称）作为输出的序数比例尺，非常适合比较苹果和橘子。
- ==`schemeCategory10`、`schemeCategory20`、`schemeCategory20b` 和 `schemeCategory20c`，能够输出 10 或 20 种分类颜色的预设序数比例尺，非常方便==。
- `scaleTime()`，时间比例尺

#### 平方根比例尺

```javascript
    //Width and height
    var w = 500;
    var h = 300;
    var padding = 20;

    var dataset = [
      [5, 20], [480, 90], [250, 50], [100, 33], [330, 95],
      [410, 12], [475, 44], [25, 67], [85, 21], [220, 88],
      [600, 150]
    ];

    //Create scale functions
    var xScale = d3.scaleLinear()
      .domain([0, d3.max(dataset, function (d) { return d[0]; })])
      .range([padding, w - padding * 2]);

    var yScale = d3.scaleLinear()
      .domain([0, d3.max(dataset, function (d) { return d[1]; })])
      .range([h - padding, padding]);

    var aScale = d3.scaleSqrt() //平方根比例尺
      .domain([0, d3.max(dataset, function (d) { return d[1]; })])
      .range([0, 10]);

    //Create SVG element
    var svg = d3.select("body")
      .append("svg")
      .attr("width", w)
      .attr("height", h);

    //Create circles
    svg.selectAll("circle")
      .data(dataset)
      .enter()
      .append("circle")
      .attr("cx", function (d) {
        return xScale(d[0]);
      })
      .attr("cy", function (d) {
        return yScale(d[1]);
      })
      .attr("r", function (d) {
        return aScale(d[1]);
      });

    //Create labels
    svg.selectAll("text")
      .data(dataset)
      .enter()
      .append("text")
      .text(function (d) {
        return d[0] + "," + d[1];
      })
      .attr("x", function (d) {
        return xScale(d[0]);
      })
      .attr("y", function (d) {
        return yScale(d[1]);
      })
      .attr("font-family", "sans-serif")
      .attr("font-size", "11px")
      .attr("fill", "red");
```

#### 时间比例尺

JavaScript 和 D3 只能对 Date 对象执行时间和日期的计算，字符串不行。d3 操作日期数据的步骤：

1. 把字符串转换成 Date 对象。`d3.timeParse()`
2. 按照所需使用时间比例尺。
3. 把 Date 对象格式化成方便人阅读的字符串，展示给用户。`d3.timeFormat();`

```html
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="utf-8">
  <title>D3: Time scale</title>
  <script type="text/javascript" src="../d3.js"></script>
  <style type="text/css">
    /* No style rules here yet */
  </style>
</head>

<body>
  <script type="text/javascript">

    //Width and height
    var w = 500;
    var h = 300;
    var padding = 40;

    var dataset, xScale, yScale;  //Empty, for now

    //For converting strings to Dates
    var parseTime = d3.timeParse("%m/%d/%y");

    //For converting Dates to strings
    var formatTime = d3.timeFormat("%b %e");

    //Function for converting CSV values from strings to Dates and numbers
    var rowConverter = d => {
      return {
        Date: parseTime(d.Date),
        Amount: parseInt(d.Amount)
      };
    }

    //Load in the data
    d3.csv("time_scale_data.csv", rowConverter)
      .then(
        data => {

          //Copy data into global dataset
          dataset = data;

          //Create scale functions
          xScale = d3.scaleTime()
            .domain([
              d3.min(dataset, d => d.Date),
              d3.max(dataset, d => d.Date)
            ])
            .range([padding, w - padding]);

          yScale = d3.scaleLinear()
            .domain([
              d3.min(dataset, d => d.Amount),
              d3.max(dataset, d => d.Amount)
            ])
            .range([h - padding, padding]);

          //Create SVG element
          var svg = d3.select("body")
            .append("svg")
            .attr("width", w)
            .attr("height", h);

          //Generate date labels first, so they are in back
          svg.selectAll("text")
            .data(dataset)
            .enter()
            .append("text")
            .text(d => formatTime(d.Date))
            .attr("x", d => xScale(d.Date) + 4)
            .attr("y", d => yScale(d.Amount) + 4)
            .attr("font-family", "sans-serif")
            .attr("font-size", "11px")
            .attr("fill", "#bbb");

          //Generate circles last, so they appear in front
          svg.selectAll("circle")
            .data(dataset)
            .enter()
            .append("circle")
            .attr("cx", d => xScale(d.Date))
            .attr("cy", d => yScale(d.Amount))
            .attr("r", 2);
        }
      );

  </script>
</body>

</html>
```



## 08 坐标轴

==比例尺是纯粹数学上的映射，与DOM无关；而坐标轴是是图元的集合，关联DOM的。==

### 定义坐标轴

坐标轴定义函数有4个：`d3.axisTop()`, `d3.axisBottom()`, `d3.axisLeft()`, `d3.axisRight()`，其中的上下左右分别表示==轴须（tick）和标签相对于轴的方位==。

==数轴对象的`.scale()`方法，传入定义好的比例尺作为参数==，`d3.axisBottom().scale(xScale)`等价于`d3.axisBottom(xScale)`

```javascript
let xAxis = d3.axisBottom().scale(xScale).ticks(5); 
svg.append("g")
    .attr("class", "axis") //添加类名，便于细微操作和定义样式
    .call(xAxis) //在g元素上调用了call()，参数为数轴函数
    .attr("transform", "translate(0," + (h - padding) + ")");
```

==任何坐标轴在初始化之后会默认放置在坐标原点，需要进一步的平移==。最后一行的`transform`为变换属性，SVG的变换非常强大，包括平移、缩放、旋转。其中`translate(x, y)` 为平移变换。

### 实现坐标轴

数轴的实现通常需要`svg.append('g').call(xAxis)`这种形式，其中xAxis是前面我们定义的数轴函数。

数轴的实现实际上会把生成坐标轴相关的可见元素，包括轴线、标签和刻度，封装在一个 group 中，添加到 DOM，所以我们需要指定在 DOM 的什么地方插入这些新元素。

`.call()`将 g 元素交给`xAxis()`，`xAxis()`使数轴在g元素内部生成。数轴的轴体、轴须和坐标值都封装在g元素内，并添加到DOM中。g 在视觉上不存在实体，只是在DOM中是一个<g>标签。它能很好地组织轴体、轴须、坐标等元素。在 DOM 中，一个坐标轴 group 包含

- 一个<path>用于横跨坐标轴的覆盖范围
- 若干个刻度(.tick)
  - 每个刻度也是一个group
  - 每个刻度下属还会包含一个<line>和一个<text>
  - <line>用于展示坐标轴的轴线，如左到右或上到下
  - <text>用于展示坐标轴的刻度值，如实数、姓名、日期
- （可选）一个标签用以描述坐标轴 

坐标轴的主直线是一个path.domain节点，刻度都是line，刻度文字是text. 将数轴封装在一个g元素中，定义其类属性（如xAxis），便可以在 CSS 中方便地设置数轴的样式。

```css
g.xAxis path,
g.xAxis line{
    fill: none;
    stroke: black;
    shape-rendering: crispEdges;
}

g.xAxis text{
    font-family: sans-serif;
    font-size: 11px;
}
```

### 修改坐标轴

#### 设置数轴的样式

前面讲数轴封装在g标签中，并定义了axis类，这就使得对其样式的定义变得大大简化了。

svg的属性与css不尽相同，如填充颜色，css用color，但svg要求fill，必须用svg接受的属性名才能设定svg元素的样式。例：

```css
.axis path, .axis line{
    stroke: teal;
    shape-rendering: crispEdges; /* shape-rendering 属性能够让视觉图像更清晰，不产生锯齿。 */
}
.axis text{
    font-faimily: Optima, Futura, sans-serif;
    font-weight: bold;
    font-size: 14px;
    fill: teal;
}
```

==注意：==由于父节点的属性会影响子节点，而坐标轴默认的fill属性是none，因此如果为坐标轴添加文字label，一定手动设置文字颜色 .attr('fill', 'black')  

#### 优化刻度

定义数轴时，用`ticks(n)`粗略地指定轴须的数量（D3只将 k 值作为一个建议，更偏向整数的分段）

`tickValues([arr])`手动设置坐标轴的指定刻度

`tickSize(a[, b])`设定轴须的长度。若为两个参数，则分别指定内部刻度和两端刻度的长度

`innerTickSize()`非数轴两端的刻度的长度

`outerTickSize()`两端刻度轴须长度

`tickPadding()`设定刻度数字距离轴的间距(默认px)

格式化刻度：`.tickFormat(d3.format())`，`d3.format()`参数中的格式遵循迷你语言格式规范。

```javascript
let formatAsPercentage = d3.format(".1%");
xAxis.tickFormat(formatAsPercentage);
```

#### 标签

坐标轴的标签加入不在D3-Axis接口的负责范围内：

- 通过对坐标轴的<g>标签 .append(‘text’)来实现
- （左）纵轴坐标需要 .attr(‘transform’, ‘rotate(-90)’) 来旋转
- 纵轴坐标旋转后， x / y 会颠倒甚至取值范围相反
- 回忆DOM：父节点的属性会影响子节点，而坐标轴默认的’fill’属性是‘none’，因此请一定手动设置文字颜色 .attr('fill', 'black')  

#### 时间数轴

```javascript
    //Width and height
    var w = 500;
    var h = 300;
    var padding = 40;

    var dataset, xScale, yScale, xAxis, yAxis;  //Empty, for now

    //For converting strings to Dates
    var parseTime = d3.timeParse("%m/%d/%y");

    //For converting Dates to strings
    var formatTime = d3.timeFormat("%e");

    //Function for converting CSV values from strings to Dates and numbers
    var rowConverter = function (d) {
      return {
        Date: parseTime(d.Date),
        Amount: parseInt(d.Amount)
      };
    }

    //Load in the data
    d3.csv("time_scale_data.csv", rowConverter)
      .then(
        data => {

          //Copy data into global dataset
          dataset = data;

          //Discover start and end dates in dataset
          var startDate = d3.min(dataset, d => d.Date);
          var endDate = d3.max(dataset, d => d.Date);

          //Create scales
          xScale = d3.scaleTime()
            .domain([
              d3.timeDay.offset(startDate, -1),  //startDate minus one day, for padding
              d3.timeDay.offset(endDate, 1)	  //endDate plus one day, for padding
            ])
            .range([padding, w - padding]);
          yScale = d3.scaleLinear()
            .domain([0, d3.max(dataset, d => d.Amount)])
            .range([h - padding, padding]);

          //Define axis
          xAxis = d3.axisBottom()
            .scale(xScale)
            .ticks(9)
            .tickFormat(formatTime);
          yAxis = d3.axisLeft()
            .scale(yScale)
            .ticks(10);

          //Create SVG element
          var svg = d3.select("body")
            .append("svg")
            .attr("width", w)
            .attr("height", h);

          //添加一系列辅助线
          svg.selectAll("line") //line 元素
            .data(dataset)
            .enter()
            .append("line")
            .attr("x1", d => xScale(d.Date))
            .attr("x2", d => xScale(d.Date))
            .attr("y1", h - padding)
            .attr("y2", d => yScale(d.Amount))
            .attr("stroke", "#ddd")
            .attr("stroke-width", 1);

          //Generate circles last, so they appear in front
          svg.selectAll("circle")
            .data(dataset)
            .enter()
            .append("circle")
            .attr("cx", d => xScale(d.Date))
            .attr("cy", d => yScale(d.Amount))
            .attr("r", 2);

          //Create X axis
          svg.append("g")
            .attr("class", "axis")
            .attr("transform", "translate(0," + (h - padding) + ")")
            .call(xAxis);

          //Create Y axis
          svg.append("g")
            .attr("class", "axis")
            .attr("transform", "translate(" + padding + ",0)")
            .call(yAxis);

        });
```


[TOC]

## 06 基本图形

### 圆形

```javascript
//画圆    

    //全局对象中存储全局变量
    let Global = {
      width: 500,
      height: 50
    };

    //Data
    var dataset = [5, 10, 15, 20, 25];

    //Create SVG element
    var svg = d3.select("body")
      .append("svg")
      .attr("width", Global.width)
      .attr("height", Global.height);


    var circles = svg.selectAll("circle")
      .data(dataset)
      .enter()
      .append("circle");

    circles.attr("cx", (d, i) => (i * 50) + 25) //对i的循环从0开始
      .attr("cy", Global.height / 2)
      .attr("r", d => d)
      .attr("fill", "yellow")
      .attr("stroke", "orange")
      .attr("stroke-width", d => d / 5);
```

### 条形图

```javascript
    //Width and height
    var w = 500;
    var h = 100;
    var barPadding = 1;

    var dataset = [5, 10, 13, 19, 21, 25, 22, 18, 15, 13,
      11, 12, 15, 20, 18, 17, 16, 18, 23, 25];

    //Create SVG element
    var svg = d3.select("body")
      .append("svg")
      .attr("width", w)
      .attr("height", h);

    svg.selectAll("rect")
      .data(dataset)
      .enter()
      .append("rect")
      .attr("x", (d, i) => i * (w / dataset.length))
      .attr("y", d => h - (d * 4))
      .attr("width", w / dataset.length - barPadding)
      .attr("height", d => d * 4)
      .attr("fill", d => "rgb(0, 0, " + Math.round(d * 10) + ")");

    svg.selectAll("text")
      .data(dataset)
      .enter()
      .append("text")
      .text(d => d)
      .attr("text-anchor", "middle") //文本以指定的x坐标为基准水平居中
      .attr("x", (d, i) => i * (w / dataset.length) + (w / dataset.length - barPadding) / 2)
      .attr("y", d => h - (d * 4) + 14)
      .attr("font-family", "sans-serif")
      .attr("font-size", "11px")
      .attr("fill", "white");
```

### 散点图

```javascript
    //Width and height
    var w = 500;
    var h = 100;

    var dataset = [
      [5, 20], [480, 90], [250, 50], [100, 33], [330, 95],
      [410, 12], [475, 44], [25, 67], [85, 21], [220, 88]
    ];

    //Create SVG element
    var svg = d3.select("body")
      .append("svg")
      .attr("width", w)
      .attr("height", h);

    svg.selectAll("circle")
      .data(dataset)
      .enter()
      .append("circle")
      .attr("cx", d => d[0])
      .attr("cy", d => d[1])
      .attr("r", d => Math.sqrt(h - d[1]));

    svg.selectAll("text")
      .data(dataset)
      .enter()
      .append("text")
      .text(d => d[0] + "," + d[1])
      .attr("x", d => d[0])
      .attr("y", d => d[1])
      .attr("font-family", "sans-serif")
      .attr("font-size", "11px")
      .attr("fill", "red");
```





## 13 布局

### Histogram

[d3.layout.histogram](https://github.com/mbostock/d3/wiki/Histogram-Layout#wiki-histogram) - 构建一个默认直方图(用来表示一组离散数字的分布,横轴表示区间,纵轴表示区间内样本数量或样本百分比).



### Pie

- [d3.layout.pie](https://github.com/mbostock/d3/wiki/Pie-Layout#wiki-pie) - 构建一个默认的饼图.
- [pie](https://github.com/mbostock/d3/wiki/Pie-Layout#wiki-_pie) - 该函数将传入的原始参数转换成可用于饼图或者环形图的[数据结构](http://lib.csdn.net/base/datastructure).
- [pie.value](https://github.com/mbostock/d3/wiki/Pie-Layout#wiki-value) - 获取或设置值访问器.
- [pie.sort](https://github.com/mbostock/d3/wiki/Pie-Layout#wiki-sort) - 设置饼图顺时针方向的排序方法.
- [pie.startAngle](https://github.com/mbostock/d3/wiki/Pie-Layout#wiki-startAngle) - 设置或获取整个饼图的起始角度.
- [pie.endAngle](https://github.com/mbostock/d3/wiki/Pie-Layout#wiki-endAngle) - 设置或获取整个饼图的终止角度

### Stack

堆叠条形和区域。

### Tree



### Force-directed

#### 数据源

D3 的力导向布局需要我们分别提供 nodes 和 edges，而且==都是对象数组==的形式。edges 的对象里有两个变量 source 和 target，分别表示连线两端的节点，其值为端点在 nodes 数组中的 index。注意，==此处必须使用 source 和target这两个名称==。

nodes 和 edges 可以是两个独立的数组，也可以封装到一个大对象里。

#### 原理

任意两点之间都存在库伦斥力，可以使它们不会相距太近；同时让==有关系的点之间存在胡克弹力==，可以使它们不会相距太远。

#### force生成器

nodes之间可以有多种力。斥力会使粒子相互远离，避免在视觉上重叠，而引力可以防止它们离得太远，保证我们能在屏幕上看到它们。

力模拟器：`let simulation = d3.forceSimulation().force(forceName, forceType)`

- 定义时可以为力指定任意名称（便于后面引用）以及相应的力函数名称。
- 力导向布局中==通常存在多个力共同竞争，它们会推挤比自己弱的节点与连线，最终达到平衡==。
- `d3.forceManyBody().strength()`，万有引/斥力，作用于所有节点两两之间的力，strength()的参数为正表示相吸，为负表示相斥，默认值为-30
  - 为了让图充分展开，可以把strength()的参数的绝对值调大
  - strength()的参数也可以是一个匿名函数，使斥力体现出node的异质性，可以形象地称之为电荷量charge或质量
- `d3.forceLink().links(edges).distance().strength()`，弹簧力。distance()的参数默认为30像素，edge两端的节点距离超过这个值时会受到引力，小于这个值时会受到斥力。因此，这种力会尽量让节点间连线距离满足这个值。
- `d3.forceCenter().x().y()`，中心引力，这种力会尽可能让粒子向坐标[x(), y()]靠近或重合，x()和y()可以接受数值或回调函数。
- `d3.forceX().strength()`，X方向上向某个坐标（或回调函数）靠近
- `d3.forceY().strength()`，Y方向上向某个坐标（或回调函数）靠近
- `d3.forceCollide(radius)`，碰撞力，确保 nodes 之间不会重合，radius 为碰撞半径，即其他节点的边缘到本节点的圆心的距离不能小于radius。
- `simulation.velocityDecay(decay)`，粒子运动的“空气阻力”，因此速度会逐渐降低。参数为1时，摩擦力最大，粒子只能移动一期；参数为0时，无摩擦力。默认参数为0.4。
- `simulation.nodes()`无参数为获取数据，有参数为绑定nodes数据
- `simulation.force(forceLink力的字符串名称).links()`无参数为获取数据，有参数为绑定edges数据

同一个力导向布局作用在不同的数据集上会产生迥然不同的结果。你最好按自己需要修改其中的每个力，从而为自己的数据集生成最清晰易懂、最值得探索并且最有意义的组合。

```javascript
    let simulation = d3.forceSimulation(nodes)
      .force('coulomb', d3.forceManyBody().strength(-1000)) //库伦斥力
      .force('center', d3.forceCenter(width / 2, height / 2)) //中心位置
      .force("hooke", d3.forceLink(edges).strength(1).distance(d => 30 * d.weight)) //胡克弹力，间距对weights加权
```

#### fore的实现

D3 的力模拟生成器会在每个时间步内==根据初始化布局时指定的规则，调整所有节点和连线的位置值。D3 自动计算好这些位置坐标，添加到内存里的数据中（会改变数据，这是 force 与其他布局的一个区别），再映射到 DOM 图元的平移属性上==，要想亲眼看到这个过程，就要逐步更新相应的连线和圆圈元素。

监听器：`force.on()` 可为三种事件设定监听器：start、tick、end。其中，start是刚开始运动，end是运动停止，tick是表示运动的每一步，用来更新nodes的运动属性。

d3.drag() 方法。该方法会依次为三个拖曳相关事件（字符串命名）设置事件监听器，并指定这些事件发生时所触发的函数。

```javascript
    //Width and height
    var w = 500;
    var h = 300;

    //Original data
    var dataset = {
      nodes: [
        { name: "Adam" },
        { name: "Bob" },
        { name: "Carrie" },
        { name: "Donovan" },
        { name: "Edward" },
        { name: "Felicity" },
        { name: "George" },
        { name: "Hannah" },
        { name: "Iris" },
        { name: "Jerry" }
      ],
      edges: [
        { source: 0, target: 1 },
        { source: 0, target: 2 },
        { source: 0, target: 3 },
        { source: 0, target: 4 },
        { source: 1, target: 5 },
        { source: 2, target: 5 },
        { source: 2, target: 5 },
        { source: 3, target: 4 },
        { source: 5, target: 8 },
        { source: 5, target: 9 },
        { source: 6, target: 7 },
        { source: 7, target: 8 },
        { source: 8, target: 9 }
      ]
    };

    //Initialize a simple force layout, using the nodes and edges in dataset
    var force = d3.forceSimulation(dataset.nodes)
      .force("charge", d3.forceManyBody())
      .force("link", d3.forceLink(dataset.edges))
      .force("center", d3.forceCenter().x(w / 2).y(h / 2));

    var colors = d3.scaleOrdinal(d3.schemeCategory10);

    //Create SVG element
    var svg = d3.select("body")
      .append("svg")
      .attr("width", w)
      .attr("height", h);

    //Create edges as lines
    var edges = svg.selectAll("line")
      .data(dataset.edges)
      .enter()
      .append("line")
      .style("stroke", "#ccc")
      .style("stroke-width", 1);

    //Create nodes as circles
    var nodes = svg.selectAll("circle")
      .data(dataset.nodes)
      .enter()
      .append("circle")
      .attr("r", 10)
      .style("fill", function (d, i) {
        return colors(i);
      })
      .call(d3.drag()  //添加可拖拽功能，定义相关事件发生时执行什么函数
        .on("start", dragStarted)
        .on("drag", dragging)
        .on("end", dragEnded));

    //Add a simple tooltip
    nodes.append("title")
      .text(function (d) {
        return d.name;
      });

    //Every time the simulation "ticks", this will be called
    force.on("tick", function () {

      edges.attr("x1", function (d) { return d.source.x; })
        .attr("y1", function (d) { return d.source.y; })
        .attr("x2", function (d) { return d.target.x; })
        .attr("y2", function (d) { return d.target.y; });

      nodes.attr("cx", function (d) { return d.x; })
        .attr("cy", function (d) { return d.y; });

    });

    //Define drag event functions
    function dragStarted(d) {
      if (!d3.event.active) force.alphaTarget(0.3).restart();
      d.fx = d.x;
      d.fy = d.y;
    }

    function dragging(d) {
      d.fx = d3.event.x;
      d.fy = d3.event.y;
    }

    function dragEnded(d) {
      if (!d3.event.active) force.alphaTarget(0);
      d.fx = null;
      d.fy = null;
    }
```








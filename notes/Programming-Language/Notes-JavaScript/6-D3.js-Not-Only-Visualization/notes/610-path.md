

## 11 路径/Path

Path可以制作折线图、地图、主题河流等。

### Path in DOM

#### 属性

- d
- fill
- stroke
- stroke-width
- transform，平移时值为`"translate(x, y)"`

#### d属性

DOM中path元素的d属性形如：

```html
<!-- 粉色正方形 -->
<path d="M10 10 h 80 v 80 h -80 Z" fill="pink" stroke="black" stroke-width="3" />
```

d属性的值是一个命令+参数的序列（字符串），实为画笔的移动轨迹（就像python的turtle库）。字符串中每个字母都表示一种命令：

- M X,Y = move 将画笔移动到指定的坐标位置
- L X,Y = line 画直线到指定的坐标位置
- H X = horizontal line 画水平线到指定的X坐标位置
- V Y = vertical line 画垂直线到指定的Y坐标位置
- C X1,Y1,X2,Y2,ENDX,ENDY = curve 三次贝塞尔曲线经两个指定控制点到达终点。曲线沿着起点到（X1, Y1）的方向伸出，逐渐弯曲，然后沿着（X2, Y2）到（ENDX, ENDY）的方向结束。  
- S X2,Y2,ENDX,ENDY = smooth curve 与前一条三次贝塞尔曲线相连，第一个控制点为前一条曲线第二个控制点的对称点，只需输入第二个控制点和终点，即可绘制一个三次贝塞尔曲线
- Q X,Y,ENDX,ENDY = quadratic Bézier curve 画二次贝塞尔曲线经一个指定控制点到达终点坐标
- T ENDX,ENDY = smooth quadratic Bézier curve 与前一条二次贝塞尔曲线相连，控制点为前一条二次贝塞尔曲线控制点的对称点，只需输入终点，即可绘制一个二次贝塞尔曲线。
- A RX,RY,XROTATION,FLAG1,FLAG2,X,Y = elliptical Arc 椭圆曲线。前两个参数分别是x轴半径和y轴半径。第三个参数x轴的旋转角度，表示弧形整体的旋转。FLAG1表示弧线是大于还是小于180度，0表示小角度弧，1表示大角度弧。FLAG2表示弧线方向，0表示从起点到终点沿逆时针画弧，1表示沿顺时针画弧。  
- Z = closepath 关闭路径，从当前点画一条直线到路径的起点  

以上所有命令均允许小写字母。大写表示绝对坐标，小写表示相对坐标（相对当前画笔所在点）。

#### D3操作path节点的原理

理论上path是可以手写添加到DOM中的，但这样太麻烦了，抽象层次太低。

D3首先给path元素绑定数据，然后给d属性传入一个回调函数（`selection.attr("d", f)`），回调函数作用于数据产生命令+参数序列，然后将此path元素添加到DOM中。用户只需关注数据即可。

#### 各种path生成器

- d3.line().x().y()，线条生成器，用于折线图
- d3.geoPath().projection()，用于地图
- d3.area()，区域生成器，用于河流图
- d3.arc().innerRadius().outerRadius()，扇形生成器，用于饼图
- d3.lineRadial().angle().radius()，弧线生成器，极坐标系版本的d3.line()  

### 线条生成器

#### `d3.line().x(f1).y(f2)`

本质上是一个回调函数。f1和f2两个匿名函数确定该线条x和y坐标的生成方式。

```javascript
          //define line generator
          line = d3.line()
            .x(d => xScale(d.date))
            .y(d => yScale(d.average));

          //create line
          svg.append("path") //添加path元素
            .datum(dataset) //绑定数据，注意不是用data()而要用datum()，因为path是一个整体
            .attr("class", "line") 
            .attr("d", line); //在d属性中调用线条生成器
```

#### `.defined() `筛选数据点

线条生成器的`defined()`方法在代码执行时判断每个值是否有定义（或者有效）。如果它参数中的匿名函数返回 true，对应的数据值就会被绘制，反之就不绘制。

```javascript
        line = d3.line()
          .defined(d => d.average >= 0) //去掉负值点
          .x(d => xScale(d.date)})
          .y(d => yScale(d.average));
```

利用该功能可以根据数据特性绘出不同的线以体现数据的性质：[chapter_11/05_line_chart_labeled.html](chapter_11/05_line_chart_labeled.html). 下图中蓝色和红色的两条线就是用不同的`defined()`定义的两个线条生成器绘制的两个path（`svg.append("path")`）. 红色虚线是`line`元素(`svg.append("line")`)

![dvw2_1108](http://humoon-image-hosting-service.oss-cn-beijing.aliyuncs.com/img/typora/JavaScript/dvw2_1108.png)

#### `line.curve()`对线条的插值/拟合方法

```javascript
const line = d3.line()
        .x(d => { return xScale(xValue(d)) })
        .y(d => { return yScale(yValue(d)) })
        //.curve(d3.curveBasis)
        .curve(d3.curveCardinal.tension(0.5)) //d3.curveCardinal.tension(0.5)可以保证拟合的曲线一定经过每个数据点，tension()的参数决定平滑度
```

#### 线条path的fill属性

若折线图下覆盖了黑色块，则要把path的fill属性设置为none



### 区域生成器

#### `d3.area().x().y0().y1()`

区域就是横坐标取值相同的两条线——y0(x)和y1(x)——之间的部分

区域生成器同样是一个回调函数，传给path元素的d属性后生成画笔的轨迹（命令+参数序列）

```javascript
        //Define area generators
        area = d3.area()
          .defined(function (d) { return d.average >= 0; })
          .x(function (d) { return xScale(d.date); })
          .y0(function () { return yScale.range()[0]; }) //y轴的下限
          .y1(function (d) { return yScale(d.average); });

        dangerArea = d3.area()
          .defined(function (d) { return d.average >= 350; })
          .x(function (d) { return xScale(d.date); })
          .y0(function () { return yScale(350); })
          .y1(function (d) { return yScale(d.average); });

        //Create SVG element
        var svg = d3.select("body")
          .append("svg")
          .attr("width", w)
          .attr("height", h);

        //Create areas
        svg.append("path")
          .datum(dataset)
          .attr("class", "area")
          .attr("d", area); //仍然在d属性中调用生成器

        svg.append("path")
          .datum(dataset)
          .attr("class", "area danger")
          .attr("d", dangerArea);
```

![dvw2_1110](http://humoon-image-hosting-service.oss-cn-beijing.aliyuncs.com/img/typora/JavaScript/dvw2_1110.png)

区域图有个缺点：如果有缺失的数据点，会非常明显地体现出来。

### 扇形生成器

#### `d3.arc().innerRadius().outerRadius()`

转换函数`d3.pie()`能把数值数组转换为对象数组，以方便更基本的函数调用来绘图。

饼图布局会自动按照从大到小的顺序排列数据值，无法自定义。

![dvw2_1303](http://humoon-image-hosting-service.oss-cn-beijing.aliyuncs.com/img/typora/JavaScript/dvw2_1303.png)

```javascript
    // global variable
    let w = 300;
    let h = 300;
    var outerRadius = w / 2;
    var innerRadius = w / 3;

    // data
    var dataset = [5, 10, 20, 45, 6, 25];
    var pie = d3.pie(); //转换函数，该函数可以将数值数组转换为Pie布局的对象数组
    let dataPie = pie(dataset);

    // 扇形生成器，类似线条生成器和区域生成器
    var arc = d3.arc()
      .innerRadius(innerRadius)
      .outerRadius(outerRadius);

    //自动生成一个调色板（序数到颜色的映射）
    //Easy colors accessible via a 10-step ordinal scale
    var color = d3.scaleOrdinal(d3.schemeCategory10);


    //SVG
    var svg = d3.select("body")
      .append("svg")
      .attr("width", w)
      .attr("height", h);

    //每个扇形都封装成一个g.arc节点，它们的起点都设定在圆心
    let arcs = svg.selectAll("g.arc")
      .data(dataPie) //绑定数据
      .enter()
      .append("g")
      .attr("class", "arc")
      .attr("transform", "translate(" + outerRadius + "," + outerRadius + ")");

    //在DOM中添加 n 个g.arc>path节点，这些path节点即扇形
    arcs.append("path")
      .attr("fill", function (d, i) {
        return color(i);
      })
      .attr("d", arc);
    //调用扇形生成器，生成每个g.arc>path节点的d属性值

    //Labels
    arcs.append("text")
      .attr("transform", function (d) {
        return "translate(" + arc.centroid(d) + ")";
        // 用扇形生成器.centroed()函数计算label相对于圆心应该移动的距离
        // .centroed()函数返回任意图形（即使是不规则形状）的中心点的坐标
      })
      .attr("text-anchor", "middle")
      .text(function (d) {
        return d.value;
        // g.arc节点绑定的是转换后的数据，所以d是一个对象
        // 要获得转换前的数值，必须用d.value提取
      });
```



### 弧线生成器

#### `d3.lineRadial().angle(…).radius(…)`




[TOC]

## 09 更新、过渡和动画

### 过渡动画

#### `.transition()`

这个函数要位于在==选择节点之后、设置任何属性之前==。

添加了 `transition()` 之后，D3 会考虑时间的因素。在旧值与新值之间插入一系列过渡值，然后根据时间推移计算两者之间的中间状态。

如果没有任何新增元素，只是既有元素的更新，就不需要`.enter().append()`：

```javascript
 svg.selectAll("rect")
     .data(new_dataset)
     .transition().ease(d3.easeLinear).duration(1000) // 过渡持续1000ms
     .attr(...) // 属性的新值
```

#### `.duration()`

指定过渡效果持续时间。==根据经验，对于细微的界面反馈（比如鼠标悬停在元素上），过渡时间大约 150 毫秒比较合适，而更显著的视觉过渡（比如整个数据视图的变化）持续 1000 毫秒比较理想==。

要让新值产生过渡效果，一定要记得先设置初始值（SVG 对象的默认值不算设置了初始值）。若无初始值，动画不会生效。

#### `.ease()`

指定插值过渡的类型，位置在`transition()`之后、`attr()`之前。

参数：

- `d3.easeLinear`线性过渡
- `d3.easeCubicOut`，动画逐渐加速再逐渐减速，适合多数平滑过渡。
- `d3.easeBounceOut`为==反复弹跳效果，仅适合用于搞笑、讽刺、挖苦的场合==。

#### transition 对象

可以定义 transition 对象，供不同图元的 .transition() 调用

`transition.end()` 返回 promise

```js
// config
const WIDTH = 1200;
const HEIGHT = 800;
const MARGIN = { top: 50, right: 50, bottom: 50, left: 50 };


// svg
const svg = d3.select('body').append('svg')
  .attr('width', WIDTH).attr('height', HEIGHT);
const g = svg.append('g')
  .attr('transform', `translate(${MARGIN.left}, ${MARGIN.top})`);


// initialization
const data = [1, 1, 1, 1, 1];
g.selectAll('rect').data(data).join('rect')
  .attr('y', (d, i) => 100 * i)
  .attr('x', 0)
  .attr('width', d => 50 * d)
  .attr('height', 50)
  .style('fill', 'black');
const rects = g.selectAll('rect');


// async sleep(delay)
const sleep = async delay => new Promise(resolve => setTimeout(resolve, delay));


// animation
(async () => {
  while (true) {
    // random width
    const newData = data.map(d => Math.random() * 10);

    // define a transition object
    const animation = d3.transition().ease(d3.easeLinear).duration(1000);

    // specification the transition object
    rects.data(newData)
      .transition(animation)
      .attr('width', d => 50 * d)
      .style('fill', d => d3.interpolateRainbow(Math.random()));

    // transition.end() return Promise
    await animation.end();
    await sleep(500);
  }
})();
```

#### `delay()`

指定过渡开始的时间，过了这段时间后才会开始过渡。更有意思的是可以动态计算延迟时间（给`delay()`传入一个匿名函数）。动态延迟的一个常见用途就是创建交错延迟的效果，==让某些元素的过渡在其他元素之前发生。交错延迟对人的感知有利，因为当相邻元素的变化不那么同步时，人眼更容易注意到每个元素的变化==。例：

![delay()](http://humoon-image-hosting-service.oss-cn-beijing.aliyuncs.com/img/typora/JavaScript/delay().gif)

```html
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="utf-8">
  <title>D3: A dynamic, per-element delay before transition</title>
  <script type="text/javascript" src="../d3.js"></script>
  <style type="text/css">
    /* No style rules here yet */
  </style>
</head>

<body>

  <p>Click on this text to update the chart with new data values (once).</p>

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
      });

    //Create labels
    svg.selectAll("text")
      .data(dataset)
      .enter()
      .append("text")
      .text(function (d) {
        return d;
      })
      .attr("text-anchor", "middle")
      .attr("x", function (d, i) {
        return xScale(i) + xScale.bandwidth() / 2;
      })
      .attr("y", function (d) {
        return h - yScale(d) + 14;
      })
      .attr("font-family", "sans-serif")
      .attr("font-size", "11px")
      .attr("fill", "white");


    //On click, update with new data			
    d3.select("p")
      .on("click", function () {

        //New values for dataset
        dataset = [11, 12, 15, 20, 18, 17, 16, 18, 23, 25,
          5, 10, 13, 19, 21, 25, 22, 18, 15, 13];

        //Update all rects
        svg.selectAll("rect")
          .data(dataset)
          .transition()
          .delay(function (d, i) {
            return i * 100;		// One-tenth of an additional second delay for each subsequent element 
          })
          .duration(500)
          .attr("y", function (d) {
            return h - yScale(d);
          })
          .attr("height", function (d) {
            return yScale(d);
          })
          .attr("fill", function (d) {
            return "rgb(0, 0, " + Math.round(d * 10) + ")";
          });

        //Update all labels
        svg.selectAll("text")
          .data(dataset)
          .transition()
          .delay(function (d, i) {
            return i * 100;
          })
          .duration(500)
          .text(function (d) {
            return d;
          })
          .attr("x", function (d, i) {
            return xScale(i) + xScale.bandwidth() / 2;
          })
          .attr("y", function (d) {
            return h - yScale(d) + 14;
          });

      });


  </script>
</body>

</html>
```

假如没有延迟，所有元素都会用 500 毫秒完成动画。但如果依次给每个元素设定了 100 毫秒的延迟（i * 100），那么所有过渡动画的总时间将为 i 的最大值乘以100毫秒延迟加上500毫秒持续时间= 19 * 100 + 500 = 2400 ms. 因为这种延迟会逐个元素累积，所以数据值越多，全部过渡动画运行的总时间就越长。

如果数据的规模非常大，就要考虑到这个因素，根据数据规模调整延迟时间。为此可以将代码写为：

``` javascript
	.transition()
    .delay(function (d, i) {
        return i / dataset.length * 1000;
    })
	.duration(500)
```

 则动画的总时长恒等于 dataset.length * (1000 / dataset.length) + 500 = 1500 ms.

#### `transition.tween()`

 使某个属性过渡到一个新的属性值，该属性可以是非attr或非style属性，比如text（通过在tween()中定义插值器）

- [transition.select](https://github.com/mbostock/d3/wiki/Transitions#wiki-select) - 选择每个当前元素的某个子元素进行过渡。
- [transition.selectAll](https://github.com/mbostock/d3/wiki/Transitions#wiki-selectAll) - 选择每个当前元素的多个子元素进行过渡。
- [transition.filter](https://github.com/mbostock/d3/wiki/Transitions#wiki-filter) - 通过数据筛选出当前元素中的部分元素进行过渡。
- [transition.transition](https://github.com/mbostock/d3/wiki/Transitions#wiki-transition) - 当前过渡结束后开始新的过渡。
- [transition.remove](https://github.com/mbostock/d3/wiki/Transitions#wiki-remove) - 过渡结束后移除当前元素。
- [transition.empty](https://github.com/mbostock/d3/wiki/Transitions#wiki-empty) - 如果过渡为空就返回true。如果当前元素中没有非null元素，则此过渡为空。
- [transition.node](https://github.com/mbostock/d3/wiki/Transitions#wiki-node) - 返回过渡中的第一个元素。
- [transition.size](https://github.com/mbostock/d3/wiki/Transitions#wiki-size) - 返回过渡中当前元素的数量。
- [transition.each](https://github.com/mbostock/d3/wiki/Transitions#wiki-each) - 遍历每个元素执行操作。不指定触发类型时，立即执行操作。==当指定触发类型为'start'或'end'时,会在过渡开始或结束时执行操作==。
- [transition.call](https://github.com/mbostock/d3/wiki/Transitions#wiki-call) - 以当前过渡为this执行某个函数

#### 数据、比例尺、数轴皆可更新

![dynamic_axes](http://humoon-image-hosting-service.oss-cn-beijing.aliyuncs.com/img/typora/JavaScript/dynamic_axes.gif)

#### `on(start/end, ()=>{}))`

[selection.on](https://github.com/mbostock/d3/wiki/Selections#wiki-on) - 添加或删除事件监听器。

D3 的 `on() `方法是添加事件监听器的==简便方法==（原生js代码也可以将元素与事件绑定，但不如`on()`方便），它接受==两个参数：事件类型和监听器（匿名函数）==

`on(start, ...)`规定在过渡开始时的动作，`on(end, ...)`规定在过渡结束时的动作。

匿名函数中的`this`引用着当前元素，从而可以对其进行调整。

```javascript
//Update all circles

        svg.selectAll("circle")
          .data(dataset)
          .transition()
          .duration(1000)
          .on("start", function () { //过渡开始时变为红色大圆
            d3.select(this)
              .attr("fill", "magenta")
              .attr("r", 3);
          })
          .attr("cx", function (d) {
            return xScale(d[0]);
          })
          .attr("cy", function (d) {
            return yScale(d[1]);
          })
          .on("end", function () { //过渡结束时恢复为黑色小圆
            d3.select(this)
              .attr("fill", "black")
              .attr("r", 2);
          });
```

==默认情况下，任何元素在任意时刻都只能有一个过渡效果。新过渡效果会打断并覆盖原来的过渡效果==。可以给transition()传入一个字符串作为过渡的名称。命名后的多个过渡可以并行发生，不会互相干扰，只要它们修改的属性不是同一个。

由于过渡存在的这个问题，一定要记住通常==只能在 `on("start", ...) `里面执行立即变换，而不能再添加任何过渡效果==。

==可以用 `on("end", ...) `指定另一个过渡，因为执行 on("end", ...) 时，之前的过渡已经结束了==，因此再执行新过渡不会产生任何副作用。

但是不建议这么写，因为在逻辑上有更直接的写法：多个`.transition().duration()`的链式连接。所以，最好用链式连接方式写顺序执行的多个过渡。而对于恰好需要在过渡开始和结束时立即执行的（非过渡性）变化，使用 `on() `方法。

```javascript
//Update all circles
        svg.selectAll("circle")
          .data(dataset)
          .transition()  //过渡1
          .duration(1000)
          .on("start", function () {
            d3.select(this)
              .attr("fill", "magenta")
              .attr("r", 7);
          })
          .attr("cx", function (d) {
            return xScale(d[0]);
          })
          .attr("cy", function (d) {
            return yScale(d[1]);
          })
          .transition()
          .duration(1000)  //过渡2
          .attr("fill", "black")
          .attr("r", 2);
```



#### `setTimeout（()=>{}, delay）`

延迟delay时间后才运行f函数，与必须写在过渡链条中的`.on(end, ()=>{})`相比，setTimeout 这种写法更加自由。

### 增删节点的动画

#### 新加入节点的动画

```javascript
  let bars = svg.selectAll("rect")	 //Select all bars
          .data(new_dataset);			//'bars' is now the update selection

        bars.enter().append("rect")	//Creates a new rect
          .attr(...)	// 如果不设置新加入条的初始位置，D3会默认它是从左上角原点处冒出来的
          .merge(bars)
          .transition().duration(500)		
          .attr(...)
```

#### 删除节点的动画

从视觉角度说，先执行过渡而不只是调用 remove() 直接删除元素是个不错的做法。

本例中，我们把条形移动到了右边，也可以弄个简单的过渡，如把它们的不透明度过渡到 0。

```javascript
//未删除节点的动画如上一段代码

//被删除节点的动画代码
bars.exit()
    .transition() .duration(500) 
    .attr("x", w)		//Move past the right edge of the SVG
    .remove();   		//Deletes this element from the DOM once transition is complete
```

### 计时器

- [d3.timer](https://github.com/mbostock/d3/wiki/Transitions#wiki-d3_timer) - 开始一个定制的动画计时。功能类似于setTimeout，但内部用requestAnimationFrame实现，更高效。
- [d3.timer.flush](https://github.com/mbostock/d3/wiki/Transitions#wiki-d3_timer_flush) - 立刻执行当前没有延迟的计时。可用于处理闪屏问题。

### 插值器

- [d3.interpolate](https://github.com/mbostock/d3/wiki/Transitions#wiki-d3_interpolate) - 生成一个插值函数，在两个参数间插值。差值函数的类型会根据输入参数的类型（数字、字符串、颜色等）而自动选择。
- [interpolate](https://github.com/mbostock/d3/wiki/Transitions#wiki-_interpolate) - 插值函数。输入参数在[0, 1]之间。
- [d3.interpolateNumber](https://github.com/mbostock/d3/wiki/Transitions#wiki-d3_interpolateNumber) - 在两个数字间插值。
- [d3.interpolateRound](https://github.com/mbostock/d3/wiki/Transitions#wiki-d3_interpolateRound) - 在两个数字间插值，返回值会四舍五入取整。
- [d3.interpolateString](https://github.com/mbostock/d3/wiki/Transitions#wiki-d3_interpolateString) - 在两个字符串间插值。解析字符串中的数字，对应的数字会插值。
- [d3.interpolateRgb](https://github.com/mbostock/d3/wiki/Transitions#wiki-d3_interpolateRgb) - 在两个RGB颜色间插值。
- [d3.interpolateHsl](https://github.com/mbostock/d3/wiki/Transitions#wiki-d3_interpolateHsl) - 在两个HSL颜色间插值。
- [d3.interpolateLab](https://github.com/mbostock/d3/wiki/Transitions#wiki-d3_interpolateLab) - 在两个L*a*b*颜色间插值。
- [d3.interpolateHcl](https://github.com/mbostock/d3/wiki/Transitions#wiki-d3_interpolateHcl) - 在两个HCL颜色间插值。
- [d3.interpolateArray](https://github.com/mbostock/d3/wiki/Transitions#wiki-d3_interpolateArray) - 在两个数列间插值。d3.interpolateArray( [0, 1], [1, 10, 100] )(0.5); // returns [0.5, 5.5, 100]
- [d3.interpolateObject](https://github.com/mbostock/d3/wiki/Transitions#wiki-d3_interpolateObject) - 在两个object间插值。d3.interpolateArray( {x: 0, y: 1}, {x: 1, y: 10, z: 100} )(0.5); // returns {x: 0.5, y: 5.5, z: 100}
- [d3.interpolateTransform](https://github.com/mbostock/d3/wiki/Transitions#wiki-d3_interpolateTransform) - 在两个2D仿射变换间插值。
- [d3.interpolateZoom](https://github.com/mbostock/d3/wiki/Transitions#wiki-d3_interpolateZoom) - 在两个点之间平滑地缩放平移。[示例](http://bl.ocks.org/mbostock/3828981)
- [d3.interpolators](https://github.com/mbostock/d3/wiki/Transitions#wiki-d3_interpolators) - 添加一个自定义的插值函数
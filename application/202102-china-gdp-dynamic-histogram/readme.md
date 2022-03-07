# 中国历年GDP动态柱状图

模仿 China Daily 这张图的前半部分：

https://www.bilibili.com/video/BV1Yv4y1f7ja?from=search&seid=7327035915132938870

#### 实现逻辑

1. 一页最多容纳 BarsInScreen 个 bar，再多了，每当 enter 一个 bar，就必须同时 exit 一个 bar
2. 第一阶段：填满屏幕之前，只执行 enter
   1. 一次读取前 BarsInScreen 个数值，绑定x轴，这个数据集叫 dataJoinX
   2. 利用计数器 Ticker 和索引变量 tickerId，逐个切割数据集 dataCSV.slice(0, tickerId)，绑定数据生成 bars，这个数据集为 dataJoinBar
   3. 绑定 y 轴的数据集为 dataJoinY。首先读取 BarsInScreen/2 个数值绑定y轴，表现数据的发展趋势。之后都动态绑定y轴。dataJoinY 始终从第一个元素开始。
   4. dataJoinBar 读到第 BarsInScreen 个数值的时候，条形把屏幕填满，进入第二阶段
3. 第二阶段：填满屏幕后，同时执行 update、enter 和 exit
   1. 每一个循环，刷新 dataJoinX == dataJoinBar 和 dataJoinY，同时更新两个坐标轴和bars
   2. bar的更新方式为：enter的从右边进入，exit的从左边退出，update的向左顺移
   4. dataJoinBar读到最后一个数据后，第二阶段结束
4. 第三阶段：展现全貌
   1. dataJoinX == dataJoinBar（ == dataJoinY ）取全集，同时更新 x 轴和 bars（y轴无变化，不必更新）。
   2. bars的enter方式为从底部向上

#### 程序结构和API

```javascript

    //config settings
    const width = 950, height = 550;
    const margin = { top: 100, bottom: 50, left: 20, right: 50 };
    const periodTimeInTicker = 350;
    const BarsInScreen = 25;

    //Data and Slice
    let dataCsv = [];
    let dataJoinX = [];
    let dataJoinY = [];
    let dataJoinBar = [];

    //Selection
    let updateRects;
    let enterRects;
    let exitRects;
    let updateTexts;
    let enterTexts;
    let exitTexts;

    //global variables
    let innerWidth = width - margin.left - margin.right;
    let innerHeight = height - margin.top - margin.bottom;
    let rectStep, rectWidth;
    let svg, mainGroup, xScale, yScale, xAxis, yAxis, xGroup, yGroup;
    let tickerId = 1; //计时器循环的索引
    let keepTwoDecimals = d3.format(",.2f");


    //read original data
    function readCsv(dataPath) {
    }


    //render svg and g
    function createSvgStructure() {
    }


    //slice data
    function getDataJoinX() {
    }
    function getDataJoinY() {
    }
    function getDataJoinBar() {
    }


    //render scale and axis
    function renderXScale(dataJoinX) {
    }
    function renderYScale(dataJoinY) {
    }
    function renderXAxis(xScale) {
    }
    function renderYAxis(yScale) {
    }


    //update DOM elements
    function updateX() {
    }
    function updateY() {
    }
    //对bars的操作如果写成一个函数，内部用条件判断，会比较复杂，不如写成三个函数
    function updateBar1() {
    }
    function updateBar2() {
    }
    function updateBar3() {
    }


    //three stages
    function notFillScreen() {
      updateX();
      updateY();
      updateBar1();
    }
    function dynamicUpdate() {
      updateX();
      updateY();
      updateBar2();
    }
    function displayOverview() {
      updateX();
      updateBar3(); 
    }


    //定时器
    function ticker() {
      const ticker = d3.interval(() => {
        if (tickerId <= BarsInScreen) {
          notFillScreen(tickerId); //第一阶段，bars填满屏幕之前，只执行enter
          tickerId++;
        } else if (tickerId <= dataCsv.length) {
          dynamicUpdate(tickerId); //第二阶段，成对地enter和exit bars
          tickerId++;
        } else if (tickerId === dataCsv.length + 1) {
          displayOverview(tickerId); //第三阶段，展示图形全貌
          tickerId++;
        } else {
          ticker.stop();
        }
      }, periodTimeInTicker);
    }


    //main
    function main() {
      readCsv("./data/ChinaGDP.csv");
      createSvgStructure();
      ticker();
    }
    main();
```

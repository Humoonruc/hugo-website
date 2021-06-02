[TOC]

## 02 通用函数

全部API：https://github.com/xswei/d3js_doc/blob/master/API_Reference/API.md

D3 不仅仅是一个可视化模块，其中有大量函数是通用的。

### 数组操作

D3 的选集常常是一个数组，为了简化代码，D3 提供了一些操作数组的常用方法。 

#### 排序

`array.sort(d3.ascending)`为升序排序，

`array.sort(d3.descending)`为降序排序

#### 求值

通式：`d3.function(array[, accessor])`

第二个参数为可选函数，指定后，array 首先会==根据 accessor 所定义的映射转换成另一个数组（就像.map()中的函数）==，再传入 function 处理。如：

```js
const students = [
  { name: 'Shao-Kui', age: 25, height: 176 },
  { name: 'Wen-Yang', age: 24, height: 180 },
  { name: 'Liang Yuan', age: 29, height: 172 },
  { name: 'Wei-Yu', age: 23, height: 173 }
];

console.log(d3.max(students, d => d.age)); // 29
console.log(d3.extent(students, d => d.height)); // [172, 180]
```



`d3.min(array[, accessor])`

`d3.max(array[, accessor])`

`d3.extend(array[, accessor])`，返回[最小值, 最大值]，等价于`[d3.min(), d3.max()]`

`d3.sum(array[, accessor])`，求和

`d3.mean(array[, accessor])`，求平均值

[d3.median](https://github.com/mbostock/d3/wiki/Arrays#wiki-d3_median) - 获取数组中数字的中位数 (相当于 0.5-quantile的值).

#### 生成和操作

`d3.range([start = 0, ]stop[, step = 1])`，返回==等差数列==（这是一个数据科学中非常重要，但 JS 中不存在的函数）

`d3.shuffle(array[, lo[, hi]])`，随机排列数组

`d3.merge(arrays)`，合并两个数组

[d3.keys](https://github.com/mbostock/d3/wiki/Arrays#wiki-d3_keys) - 返回关联数组(哈希表、json、object对象)的key组成的数组.

[d3.values](https://github.com/mbostock/d3/wiki/Arrays#wiki-d3_values) - 返回关联数组的value组成的数组.

[d3.entries](https://github.com/mbostock/d3/wiki/Arrays#wiki-d3_entries) - 返回关联数组的key-value实体组成的数组, d3.entries({ foo: 42 }); // returns [{key: "foo", value: 42}].

#### 映射

`d3.map(array, f])` 第一个参数是数组，第二个参数是匿名函数，用于指定映射的规则。这个函数其实就是 `Array.map() `的 d3 版。

```javascript
let dataset = [
  { id: 1000, name: "cat", color: "orange" },
  { id: 1001, name: "dog", color: "yellow" },
  { id: 1002, name: "pig", color: "pink" }
];

let map_Pet = d3.map(dataset, (d, i) => {
  return { index: i + 1, name: d.name, };
});
console.log(map_Pet);
```

<img src="http://humoon-image-hosting-service.oss-cn-beijing.aliyuncs.com/img/typora/JavaScript/image-20210525202312517.png" alt="image-20210525202312517" style="zoom:67%;" />

#### 集合

[d3.set](https://github.com/mbostock/d3/wiki/Arrays#wiki-d3_set) - 将javascript的array转化为set,屏蔽了array的object原型链功能导致的与set不一致的问题。set中的value是array中每个值转换成字符串的结果。set中的value是去重过的。

### 随机数

https://github.com/d3/d3-random/tree/v2.2.2#d3-random

- [d3.randomUniform](https://github.com/d3/d3-random/blob/v2.2.2/README.md#randomUniform) - from a uniform distribution.
- [d3.randomNormal](https://github.com/d3/d3-random/blob/v2.2.2/README.md#randomNormal) - from a normal distribution.

### 数字格式化

https://github.com/d3/d3-format/tree/v2.0.0#d3-format

- `d3.format(specifier)` - 接受字符串标识的特定格式，返回一个函数。返回的函数能将数字转化成指定格式的字符串。转化的格式非常丰富，且非常智能。

  ```js
  console.log(d3.format('.2f')(666666.666)); // 666666.67
  console.log(d3.format('.2r')(666666.666)); // 670000
  console.log(d3.format('.2s')(666666.666)); // 670k 
  
  
  d3.format(".0%")(0.123);  // rounded percentage, "12%"
  d3.format("($.2f")(-3.5); // localized fixed-point currency, "(£3.50)"
  d3.format("+20")(42);     // space-filled and signed, "                 +42"
  d3.format(".^20")(42);    // dot-filled and centered, ".........42........."
  d3.format(".2s")(42e6);   // SI-prefix with two significant digits, "42M"
  d3.format("#x")(48879);   // prefixed lowercase hexadecimal, "0xbeef"
  d3.format(",.2r")(4223);  // grouped thousands with two significant digits, "4,200"
  ```

- `axis.tickFormat(d3.format('specifier'))` 将格式化函数传递给坐标轴

- [d3.formatPrefix](https://github.com/mbostock/d3/wiki/Formatting#wiki-d3_formatPrefix) - 以指定的值和精度获得一个[SI prefix]对象。这个函数可用来自动判断数据的量级， 如K(千)，M(百万)等等。示例: var prefix = d3.formatPrefix(1.21e9); console.log(prefix.symbol); // "G"; console.log(prefix.scale(1.21e9)); // 1.21

- [d3.requote](https://github.com/mbostock/d3/wiki/Formatting#wiki-d3_requote) - 将字符串转义成可在正则表达式中使用的格式。如 d3.requote('$'); // return "\$"

- [d3.round](https://github.com/mbostock/d3/wiki/Formatting#wiki-d3_round) - 设置某个数按小数点后多少位取整。与toFixed()类似，但返回格式为number。 如 d3.round(1.23); // return 1; d3.round(1.23, 1); // return 1.2

### 颜色

d3 的颜色比例尺：https://github.com/d3/d3-scale-chromatic



- [d3.rgb](https://github.com/mbostock/d3/wiki/Colors#wiki-d3_rgb) - 指定一种颜色，创建一个RGB颜色对象。支持多种颜色格式的输入。
- [rgb.brighter](https://github.com/mbostock/d3/wiki/Colors#wiki-rgb_brighter) - 增强颜色的亮度，变化幅度由参数决定。
- [rgb.darker](https://github.com/mbostock/d3/wiki/Colors#wiki-rgb_darker) - 减弱颜色的亮度，变化幅度由参数决定。
- [rgb.hsl](https://github.com/mbostock/d3/wiki/Colors#wiki-rgb_hsl) - 将RGB颜色对象转化成HSL颜色对象。
- [rgb.toString](https://github.com/mbostock/d3/wiki/Colors#wiki-rgb_toString) - RGB颜色转化为字符串格式。
- [d3.hsl](https://github.com/mbostock/d3/wiki/Colors#wiki-d3_hsl) - 创建一个HSL颜色对象。支持多种颜色格式的输入。
- [hsl.brighter](https://github.com/mbostock/d3/wiki/Colors#wiki-hsl_brighter) - 增强颜色的亮度，变化幅度由参数决定。
- [hsl.darker](https://github.com/mbostock/d3/wiki/Colors#wiki-hsl_darker) - 减弱颜色的亮度，变化幅度由参数决定。
- [hsl.rgb](https://github.com/mbostock/d3/wiki/Colors#wiki-hsl_rgb) - 将HSL颜色对象转化成RGB颜色对象。
- [hsl.toString](https://github.com/mbostock/d3/wiki/Colors#wiki-hsl_toString) - HSL颜色转化为字符串格式。
- [d3.lab](https://github.com/mbostock/d3/wiki/Colors#wiki-d3_lab) - 创建一个Lab颜色对象。支持多种颜色格式的输入。
- [lab.brighter](https://github.com/mbostock/d3/wiki/Colors#wiki-lab_brighter) - 增强颜色的亮度，变化幅度由参数决定。
- [lab.darker](https://github.com/mbostock/d3/wiki/Colors#wiki-lab_darker) - 减弱颜色的亮度，变化幅度由参数决定。
- [lab.rgb](https://github.com/mbostock/d3/wiki/Colors#wiki-lab_rgb) - 将Lab颜色对象转化成RGB颜色对象。
- [lab.toString](https://github.com/mbostock/d3/wiki/Colors#wiki-lab_toString) - Lab颜色转化为字符串格式。
- [d3.hcl](https://github.com/mbostock/d3/wiki/Colors#wiki-d3_hcl) - 创建一个HCL颜色对象。支持多种颜色格式的输入。
- [hcl.brighter](https://github.com/mbostock/d3/wiki/Colors#wiki-hcl_brighter) - 增强颜色的亮度，变化幅度由参数决定。
- [hcl.darker](https://github.com/mbostock/d3/wiki/Colors#wiki-hcl_darker) - 减弱颜色的亮度，变化幅度由参数决定。
- [hcl.rgb](https://github.com/mbostock/d3/wiki/Colors#wiki-hcl_rgb) - 将HCL颜色对象转化成RGB颜色对象。
- [hcl.toString](https://github.com/mbostock/d3/wiki/Colors#wiki-hcl_toString) - HCL颜色转化为字符串格式。

### 命名空间

- [d3.ns.prefix](https://github.com/mbostock/d3/wiki/Namespaces#wiki-prefix) - 获取或扩展已知的XML命名空间。
- [d3.ns.qualify](https://github.com/mbostock/d3/wiki/Namespaces#wiki-qualify) - 验证命名空间前缀是否存在, 如"xlink:href"中xlink是已知的命名空间。

### 内部方法

- [d3.functor](https://github.com/mbostock/d3/wiki/Internals#wiki-functor) - 函数化。将非函数变量转化为只返回该变量值的函数。输入函数，则返回原函数；输入值，则返回一个函数，该函数只返回原值。
- [d3.rebind](https://github.com/mbostock/d3/wiki/Internals#wiki-rebind) - 将一个对象的方法绑定到另一个对象上。
- [d3.dispatch](https://github.com/mbostock/d3/wiki/Internals#wiki-d3_dispatch) - 创建一个定制的事件。
- [dispatch.on](https://github.com/mbostock/d3/wiki/Internals#wiki-dispatch_on) - 添加或移除一个事件监听器。对一个事件可添加多个监听器。
- [dispatch.type](https://github.com/mbostock/d3/wiki/Internals#wiki-_dispatch) - 触发事件。其中‘type’为要触发的事件的名称。


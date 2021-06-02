[TOC]

## 01 Data I/O

### Input

永远不要忘记 D3.js 运行在浏览器中，需要不停地向服务器请求数据。

 ==D3 中导入数据的函数是对 Ajax 式资源请求行为的封装==。

#### 支持 async/await

==v5.0 之后，D3.js 中请求数据的 API 已经全面现代化（返回 Promise），支持 async/await 语法==。

这样，即使需要请求多个数据文件，连Promise.all()都不需要，直接写成同步形式即可。

一定要用v5.0之后的d3版本！之前的版本不支持。

```js
// 写法1：回调函数
d3.csv('../data/cities.csv', cities => {
  // ...
});

// 写法2：promise...then
d3.csv('../data/cities.csv')
  .then(cities => {
  // ...
  })

// 写法3：async/await
(async () => {
  const cities = await d3.csv('../data/cities.csv');
  // ...
})();
```

#### `d3.csv()`/`d3.csvParse()`

可以将 csv 文件/csv格式字符串读成以 js 对象为元素的数组。

`d3.csv*()` 读入数据后，将==各属性的值均作为字符串保存。所以如果像将其作为原本的数值使用，需要先转换数据类型==。

```javascript
const table = d3.csvParse("name,age\nJohn,24\nMary,15"); // 将csv格式的字符串解析为对象数组，但这个数组是一个特殊对象，额外具有属性 columns，这在使用起来非常方便！
console.log(table);
console.log(JSON.stringify(table, null, 2));
console.log(`Table is an array, isn't it? ${Array.isArray(table)}!`);
console.log(`The data type of John's age is ${typeof table[0].age} but number!`);
```

![image-20210525192228540](http://humoon-image-hosting-service.oss-cn-beijing.aliyuncs.com/img/typora/JavaScript/image-20210525192228540.png)

#### 其他函数

- d3.csvFormat - 将object的数组转化成CSV文件字符串，是d3.csvParse的逆操作。
- d3.text
- d3.json
- d3.html
- d3.xml

### Output

`console.table(dataset)`

这是console.log() 的美化版本，它会把数据用优雅美观的表格列输出到控制台。


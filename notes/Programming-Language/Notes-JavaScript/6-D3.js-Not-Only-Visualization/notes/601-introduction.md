[TOC]

# Introduction

D3全称: Data-Driven Document

信息时代可视化原则：先概览全貌，再缩放并筛选信息（能够互动），然后按需寻找细节（包含信息扩展链接）

D3不会隐藏原始数据，数据会在客户端的浏览器中保存

D3.js使用SVG渲染，p5.js使用canvas渲染，Three.js可以渲染3D场景

资源：

- https://d3js.org/ （官方网站，包括文档、样例）
- 中文资源汇总，包括示例、书籍、 API文档等: https://github.com/xswei/d3js_doc
- 中文API文档: https://github.com/xswei/d3js_doc/blob/master/API_Reference/API.md
- SVG属性表: https://developer.mozilla.org/zh-CN/docs/Web/SVG/Attribute
- Gallery, 官方样例: https://github.com/d3/d3/wiki/Gallery

## 模块化导入

### CommonJS

jsdom 可以与 d3 配合，在 Node.js 中绘制静态图片，然后使用命令

```shell
node drawCircle.js > mycircle.svg
```

导出为 .svg 文件

```js
/**
 * @module drawCircle
 * @file 使用 d3 和 JSDOM 模块绘制静态 SVG 图片
 * @author Humoonruc
 */

const d3 = require('d3');
const { JSDOM } = require("jsdom");

const jsdom = new JSDOM();
const document = jsdom.window.document;


const svg = d3.select(document.body).append('svg')
  .attr('xmlns', 'http://www.w3.org/2000/svg')
  .attr('width', 500)
  .attr('height', 500);

svg.append("circle")
  .attr("cx", 250)
  .attr("cy", 250)
  .attr("r", 250)
  .attr("fill", "Red");

console.log(document.body.innerHTML);
```

### ES6

```js
import * as d3 from "d3";

// 导入部分功能
import {select, selectAll} from "d3-selection";
import {geoPath} from "d3-geo";
import {geoPatterson} from "d3-geo-projection";
```

### 浏览器（CDN）

```html
<script src="https://cdnjs.cloudflare.com/ajax/libs/d3/6.7.0/d3.min.js"></script>
```

## 配置Web服务器

1. 浏览器为了安全，禁止JavaScript脚本访问PC本地文件，而只允许访问服务器端文件。故为了读取本地数据文件，必须建立本地服务器，使浏览器以为是从服务器端访问到的文件。
2. ==在项目文件夹建立服务器==，保证互相引用的文件（如d3.js）都在服务器文件夹之内。在这个文件夹的地址栏中，输入`cmd`回车打开 cmd
   1. Python服务器：在 cmd 中输入`python -m http.server 8000`，启动本地服务器。在浏览器中输入http://localhost:8000/以访问，根据具体需要访问的HTML文件名修改地址，如http://localhost:8000/chapter_05/03_csv_loading_example.html
   2. Node.js服务器：在 cmd 中输入`http-server -p 8080`，启动本地服务器。在浏览器中输入http://192.168.8.108:8080/或==http://127.0.0.1:8080/（推荐！）==或http://localhost:8080/以访问，根据具体需要访问的HTML文件名修改地址，如http://192.168.8.108:8080/chapter_05/02_new_element.html
3. 安装 VSCode 插件 Preview on Web Server后，在 VSCode 中打开 html 文件，可以右键`vscode-preview-server:Launch on browser`命令，在==VSCode 的当前文件夹下==开一个 8080 端口的本地服务器，然后==按照文件夹目录路由==（需要保证所有读取的文件都要在这个文件夹内部），这样就不需要写Flask或者Django等等的服务器了。


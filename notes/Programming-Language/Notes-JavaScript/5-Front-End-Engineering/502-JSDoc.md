[TOC]

## JSDoc

在脚本中标注，然后根据标注自动生成项目的文档。



### 项目地址

- [jsdoc/jsdoc: An API documentation generator for JavaScript. (github.com)](https://github.com/jsdoc/jsdoc)

### 项目文档

- [Use JSDoc: Index](https://jsdoc.app/)
- [中文文档](https://jsdoc.zcopy.site/)

### 安装

```shell
npm i jsdoc -g
npm i --save-dev jsdoc-to-markdown
```

### 使用

```shell
jsdoc xxx.js -d ./document/ # 对脚本文件生成文档，并指定输出目录，若不指定默认输出到 ./out/
jsdoc -R ./README.md -r ./src/ -d ./docs/ # 对src文件夹中所有js文件生成文档，合并README.md，最后输出到docs文件夹。这样，可以直接发布在GitHub Page上，并选择显示 /docs/ 文件下的 index.html
jsdoc2md example.js # 在终端显示md格式的文档，可以直接复制粘贴到md文件中
```

### VSCode 中的 Add jsdoc comments 插件

选中函数的首行，按`F1`，选择`Add Doc Comments`，即可自动生成函数参数的 jsdoc 注释

### 标注方法

需要标注的主要是模块说明和函数说明

```js
/**
 * @module baiduAPI
 * @file 定义翻译API
 * @author Humoonruc
 */

/**
 * 自定义的辅助 sleep() 函数，用于阻断主线程，防止访问服务器的频率过高
 * @param  {number} delay - 要停滞的毫秒数
 * @returns {Promise<void>}
 */
async function sleep(delay) {
  return new Promise(resolve => setTimeout(resolve, delay));
}
```

<img src="http://humoon-image-hosting-service.oss-cn-beijing.aliyuncs.com/img/typora/JavaScript/image-20210526142613687.png" alt="image-20210526142613687" style="zoom:50%;" />

### HTML 文档

#### 主页

![image-20210525144611759](http://humoon-image-hosting-service.oss-cn-beijing.aliyuncs.com/img/typora/JavaScript/image-20210525144611759.png)

#### 变量和方法页

![image-20210525144637712](http://humoon-image-hosting-service.oss-cn-beijing.aliyuncs.com/img/typora/JavaScript/image-20210525144637712.png)
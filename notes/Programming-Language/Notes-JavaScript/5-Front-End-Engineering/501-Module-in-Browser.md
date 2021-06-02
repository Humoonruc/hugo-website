[TOC]

## 模块——ES6 规范

[现代 JavaScript 教程-模块 (Module) 简介](https://zh.javascript.info/modules-intro#zong-jie)

### 浏览器环境下的模块

#### 语法

 script 标签中加入 type 属性（可以与 src 属性共存），其中的 `import`才能工作

```html
<script type = "module">
  import {Variable/Function/Class... as newName} from './js/xxx.js' // 获得该模块的部分 export
  import * as xxx from './js/xxx.js' // 获得该模块的所有 export
  // to do
</script>
```

#### 特性

1. 模块始终使用 `use strict`。
2. 每个模块（.js 文件）都有自己的顶级作用域（top-level scope）。换句话说，如果一个 html 文件通过`<script type = 'module' src = 'jsFilePath'>`导入了多个模块，而它们相互之间不`import`，则一个模块中的顶级作用域变量和函数在其他模块中是不可见的。
3. 每个 `<script type="module">` 标签也存在独立的顶级作用域，变量和函数互相不可见。因此一个html文件最好只有一个`<script type="module">`标签。
4. 模块代码只执行一次。导出仅创建一次，然后会在导入之间共享。

#### 打包

在生产环境中，出于性能和其他原因，开发者经常使用诸如 [Webpack](https://webpack.js.org/) 之类的打包工具将模块打包到一起。

#### 实例

```js
/**
 * @module config
 * @file 项目初始化配置，不包含账号密码等敏感信息。敏感信息放在另一个文件里，不写 JSDoc 格式的注释，不通过 git 同步。
 * @author Humoonruc
 */

export const SVG_WIDTH = 1200;
export const SVG_HEIGHT = 800;
export const PADDING = { left: 50, right: 50, top: 50, bottom: 50 };
```



```html
<body>
  <div id='mainText'>
    <h1>Main Title</h1>
  </div>

  <script type='module'>
    import * as config from './js/config.js';
    
    const main = document.querySelector('#mainText');
    const p = document.createElement('p');
    p.textContent = `width = ${config.SVG_WIDTH}, height = ${config.SVG_HEIGHT}`;
    main.appendChild(p);
    
    // const svg = d3.select('body').append('svg').attr('width', config.SVG_WIDTH).attr('height', config.SVG_HEIGHT)
  </script>
</body>
```


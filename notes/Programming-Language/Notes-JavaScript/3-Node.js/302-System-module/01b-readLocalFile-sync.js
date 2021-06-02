//@ts-check
'use strict';
//01b-readLocalFile-sync.js


const fs = require("fs");

// 非异步读取
try {
  const data = fs.readFileSync('./data/input.txt', 'utf8')
  console.log(data)
} catch (err) {
  console.error(err)
}

console.log("程序执行结束!");

// 执行结果：
// 菜鸟教程官网地址：www.runoob.com
// 程序执行结束!
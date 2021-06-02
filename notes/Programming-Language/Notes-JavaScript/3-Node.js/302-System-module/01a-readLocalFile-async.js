//@ts-check
'use strict';
//01a-readLocalFile-async.js

const fs = require("fs");

// 异步读取
fs.readFile('./data/input.txt', 'utf8', (error, data) => {
  if (error) {
    console.error(error);
    return;
  }
  console.log(data);
});

console.log("程序执行结束!");

// 执行结果：
// 程序执行结束!
// 菜鸟教程官网地址：www.runoob.com
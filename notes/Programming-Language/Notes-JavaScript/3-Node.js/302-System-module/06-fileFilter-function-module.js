'use strict'
// 06-fileFilter-function-module.js

// 这个模块的主要内容是一个筛选器


const fs = require('fs');
const path = require('path');

// 定义一个筛选器，第三个参数是回调函数
// 定义时，回调函数具体是什么不知道，调用筛选器时才具体化
function fileFilter(dirPath, fileType, callBack) {
  fs.readdir(dirPath, (error, fileArray) => {
    if (error) {
      callBack(error); //把error传递给回调函数
      return;
    }

    let filteredFiles = fileArray
      .filter(filePath =>
        path.extname(filePath) === '.' + fileType
      )

    callBack(null, filteredFiles)
    //将[null, filteredFiles]传递给回调函数
  })
}

// 导出筛选器
module.exports = fileFilter;
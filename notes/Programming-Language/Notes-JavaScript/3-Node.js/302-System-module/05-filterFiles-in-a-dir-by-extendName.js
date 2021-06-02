//@ts-check
'use strict'
// 05-filterFiles-in-a-dir-by-extendName.js
// 本脚本从一个文件夹中筛选后缀为特定扩展名的文件

const fs = require('fs')
const path = require('path')

// 从命令行参数获取文件夹路径和文件类型
const dirPath = process.argv[2]
const fileType = '.' + process.argv[3]


fs.readdir(dirPath, (err, fileArray) => {
  // fs.readdir()将目录下所有文件路径读为一个数组

  if (err) console.error(err);

  fileArray.forEach(filePath => {
    if (path.extname(filePath) === fileType) {
      // path.extname() 返回文件的扩展名
      console.log(filePath);
    }
  })
})

// node  05-filterFiles-in-a-dir-by-extendName.js  ./data/  txt

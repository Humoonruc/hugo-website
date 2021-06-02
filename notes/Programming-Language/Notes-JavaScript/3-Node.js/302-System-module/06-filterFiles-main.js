'use strict'
// 06-filterFiles-main.js

const fileFilter = require('./06-fileFilter-function-module.js')
const dirPath = process.argv[2]
const fileType = process.argv[3]

fileFilter(dirPath, fileType, function (error, list) {
  // 调用筛选器时具体化回调函数

  if (error) return console.error('There was an error:', error)

  // 正常情况下，err是null
  list.forEach(file => console.log(file))
})


// 在shell输入：node  06-filterFiles-main.js  ./data/  txt
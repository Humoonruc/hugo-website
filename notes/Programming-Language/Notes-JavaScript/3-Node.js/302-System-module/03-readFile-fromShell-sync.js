//@ts-check
'use strict'
//03-readFile-fromShell-sync.js

const fs = require('fs')

//读第一个参数所表示的文件为 Buffer 对象，再转换为字符串
// const fileText = fs.readFileSync(process.argv[2]).toString()

// 或直接读为字符串
const fileText = fs.readFileSync(process.argv[2], 'utf8')

//统计'\n'数
const nRow = fileText.split('\n').length - 1
console.log(nRow)

// 命令行输入: node 03-readFile-fromShell-sync.js ./data/input.txt
//@ts-check
'use strict'
//04-readFile-fromShell-async.js

const fs = require('fs')
const file = process.argv[2]

const fileText = fs.readFile(file, 'utf8', (err, content) => {
  if (err) {
    return console.error(err)
  }
  console.log(content.split('\n').length - 1)
})

// 命令行输入: node 04-readFile-fromShell-async.js ./data/input.txt

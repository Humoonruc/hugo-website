'use strict'
// 09-async-get.js

const http = require('http')
const bl = require('bl')
const results = []
let count = 0

function printResults() {
  for (let i = 0; i < 3; i++) {
    console.log(results[i])
  }
}

function httpGet(index) {
  http
    .get(process.argv[2 + index], response => {
      response.pipe(bl((err, data) => {
        if (err) return console.error(err);

        results[index] = data.toString()
        count++

        // printResults()必须写在http.get()之内，而不能写在全局域中
        // 否则按照异步的性质，会在服务器返回数据前先执行printResults()
        // 此时results数组仍为undefined
        if (count === 3) printResults()
      }))
    })
}

for (let i = 0; i < 3; i++) {
  httpGet(i)
}
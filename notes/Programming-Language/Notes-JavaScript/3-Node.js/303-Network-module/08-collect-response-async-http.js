'use strict'
//08-collect-response-async-http.js

const https = require('https')

const URL = "https://www.runoob.com/nodejs/nodejs-tutorial.html";

https
  .get(URL, response => {
    response.setEncoding('utf8');
    let responseString = '';

    // 服务器返回是一块一块的
    // 每次返回一块response.on()都会监控到并触发其回调函数
    response.on('data', data => responseString += data)
    response.on('end', () => {
      console.log(responseString.length)
      console.log(responseString)
    })
    response.on('error', console.error)
  })
  .on('error', console.error)
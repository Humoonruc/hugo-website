// @ts-check
'use strict'
//02-use-parameters-fromShell.js

// 读取命令行参数
// process.argv 是一个数组，包括所接受的命令行的所有部分，且为命令和文件的绝对路径
// 如果命令行为: node 02-process-argv.js ...
// 则总有 process.argv[0] 为 node 的绝对路径，process.argv[1] 为 02-process-argv.js 的绝对路径，从 process.argv[2] 起才是...那些参数

console.log("The absolute path of node: " + process.argv[0]);
console.log("The absolute path of JavaScript file: " + process.argv[1]);

let sum = 0;
for (let i = 2; i < process.argv.length; i++) {
  sum += (+process.argv[i]);
}
console.log('The sum of numbers is ' + sum);

// 命令行输入: node 02-use-parameters-fromShell.js 1 2 3 4 5 6 7
// 返回 10
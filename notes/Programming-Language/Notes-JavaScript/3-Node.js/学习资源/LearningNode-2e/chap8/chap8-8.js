'use strict';

// 这段代码并非要运行一个shell脚本，但由于是要在原本的shell内进入node交互REPL并持续接受输入，所以只能用 .execFile()
const cp = require('child_process');
const child = cp.execFile('node', ['-i'], (err, stdout, stderr) => {
  console.log(stdout);
});


child.stdin.write('process.versions;\n');
child.stdin.end();
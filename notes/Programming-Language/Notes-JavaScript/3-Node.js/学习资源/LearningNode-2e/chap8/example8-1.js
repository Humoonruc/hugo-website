// example8-1.js
// shell 命令: `dir . | findstr chap`

const spawn = require('child_process').spawn;
const dir = spawn('dir', ['.'], { shell: true });
const findstr = spawn('findstr', ['chap'], { shell: true });


findstr.stdout.setEncoding('utf8');
dir.stdout.pipe(findstr.stdin);

dir.stdout.on('data', data => console.log(`dir stdout:\n${data}`));
findstr.stdout.on('data', data => console.log(`finddir stdout:\n${data}`));


dir.stderr.on('data', data => console.error(`dir stderr: ${data}`));
findstr.stderr.on('data', data => console.error(`findstr stderr: ${data}`));


dir.on('close', code => {
  if (code !== 0) {
    console.log(`dir process exited with code ${code}`);
  }
});
findstr.on('exit', code => {
  if (code !== 0) {
    console.log(`dir process exited with code ${code}`);
  }
});
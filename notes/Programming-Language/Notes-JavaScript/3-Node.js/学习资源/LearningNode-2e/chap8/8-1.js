// 8-1.js
const spawn = require('child_process').spawn;
// const pwd = spawn('chdir', { shell: true });
const pwd = spawn('chdir', ['-p'], { shell: true });

pwd.stdout.on('data', data => console.log(`stdout: ${data}`));
pwd.stderr.on('data', data => console.error(`stderr: ${data}`));
pwd.on('close', code => console.log(`child process exited with code ${code}`));
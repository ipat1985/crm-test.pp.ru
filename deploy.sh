const { exec } = require("child_process");

const commands = [
  "git pull origin main",
  "npm install",
  "npx quasar build",
  "npx serve -s dist/spa -l " + (process.env.PORT || 8081)
];

function runCommand(cmd, cb) {
  const proc = exec(cmd, (err, stdout, stderr) => {
    if (err) {
      console.error(`Error executing: ${cmd}\n`, err);
      return cb(err);
    }
    console.log(stdout);
    console.error(stderr);
    cb();
  });

  proc.stdout.pipe(process.stdout);
  proc.stderr.pipe(process.stderr);
}

function runAll(commands) {
  if (commands.length === 0) return;
  const cmd = commands.shift();
  runCommand(cmd, (err) => {
    if (err) return;
    runAll(commands);
  });
}

runAll(commands);

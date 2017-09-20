// Misc gulp tasks related to processing examples
'use strict';

module.exports = function (gulp, plugins, config) {

  const EXAMPLES_ROOT = config.EXAMPLES_ROOT;
  const argv = plugins.argv;
  const cp = plugins.child_process;
  const filter = plugins.filter;
  const gutil = plugins.gutil;
  const path = plugins.path;

  const findCmd = `find ${EXAMPLES_ROOT} -type f -name "pubspec.yaml" ! -path "*/.*"`;
  const findOutput = (cp.execSync(findCmd) + '').split(/\s+/).filter(p => p); // drop empty paths
  const examplesFullPath = findOutput.map(p => path.dirname(p));
  const examples = examplesFullPath.map(p => path.basename(p));

  gulp.task('__list-example-paths', () => {
    gutil.log(`example paths:\n  ${examplesFullPath.join('\n  ')}`);
    gutil.log(`find output:\n[${findOutput}]`);
  });

  gulp.task('examples-pub-upgrade-and-check', (doneCb) =>
    plugins.runSequence('examples-pub-upgrade', 'git-check-diff', doneCb));

  gulp.task('examples-pub-upgrade', () => examplesExec('pub upgrade'));

  gulp.task('git-check-diff', () => {
    _exec('git status --short') && process.exit(1);
    // _exec('git add .');
    // const diff = _exec('git diff-index --quiet HEAD');
    // if (diff) ;
  });

  // General exec task. Args: --exec='some-cmd with args'
  gulp.task('examples-exec', () => examplesExec(argv.exec));

  function examplesExec(cmd) {
    if (!cmd) throw `Invalid command: ${cmd}`;

    examplesFullPath.forEach((exPath) => {
      gutil.log(`\nExample: ${exPath}; cmd: ${cmd}`);
      console.log(cp.execSync(cmd, { cwd: exPath }) + '');
    });
  }

  function _exec(cmd) {
    gutil.log(`+ ${cmd}`);
    const output = cp.execSync(cmd) + '';
    gutil.log(output);
    return output;
  }
};

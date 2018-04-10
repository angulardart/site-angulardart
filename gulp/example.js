// Misc gulp tasks related to processing examples
'use strict';

module.exports = function (gulp, plugins, config) {

  const EXAMPLES_ROOT = config.EXAMPLES_ROOT;
  const argv = plugins.argv;
  const cp = plugins.child_process;
  const _exec = plugins.execSyncAndLog;
  const filter = plugins.filter;
  const gutil = plugins.gutil;
  const path = plugins.path;

  const chooseRegEx = argv.filter || '.';
  const skipRegEx = argv.skip || null;

  const findCmd = `find ${EXAMPLES_ROOT} -type f -name "pubspec.yaml" ! -path "*/.*" ! -path "*/build/*" `;
  const findOutput = (cp.execSync(findCmd) + '').split(/\s+/).filter(p => p); // drop empty paths
  const examplesFullPath = findOutput.map(p => path.dirname(p))
    .filter(p => !p.match(skipRegEx))
    .filter(p => p.match(chooseRegEx))
    .sort();
  // const examples = examplesFullPath.map(p => path.basename(p));

  gulp.task('__list-example-paths', () => {
    gutil.log(`example paths:\n  ${examplesFullPath.join('\n  ')}`);
    gutil.log(`find output:\n[${findOutput}]`);
  });

  ['get', 'upgrade'].forEach(cmd => {
    gulp.task(`examples-pub-${cmd}`, () => examplesExec(`pub ${cmd}`));
  });

  // General exec task. Args: --cmd='some-cmd with args'
  gulp.task('examples-exec', () => examplesExec(argv.cmd));

  function examplesExec(cmd) {
    if (!cmd) throw `Invalid command: ${cmd}`;
    examplesFullPath.forEach((exPath) => {
      _exec(cmd, { cwd: exPath });
    });
  }

};

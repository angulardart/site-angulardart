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

  // ==========================================================================
  // Boilerplate management

  const boilerplateSrcDirs = [config.EXAMPLES_ROOT, config.EXAMPLES_NG_DOC_PATH];
  let bpDeps = [];
  boilerplateSrcDirs.forEach((bpParentDir, i) => {
    const target = `_add-example-boilerplate-${i}`;
    bpDeps.push(target);
    const examplePaths = examplesFullPath.filter(p => p.startsWith(bpParentDir));
    gulp.task(target, () => _addExampleBoilerplate(boilerplateSrcDirs[i], examplePaths));
  });

  gulp.task('add-example-boilerplate', bpDeps);

  function _addExampleBoilerplate(bpParentDir, examplePaths) {
    if (examplePaths.length === 0) return;

    const baseDir = path.join(bpParentDir, '_boilerplate');
    let stream = gulp.src([
      `${baseDir}/.gitignore`,
      `${baseDir}/**`,
    ], { base: baseDir })
    .pipe(plugins.chmod(0o444));

    examplePaths.forEach(exPath => {
      stream = stream.pipe(gulp.dest(exPath));
    });
    return stream;
  }

  gulp.task('git-clean-example', () => examplesExec('git clean -xdf'));

}

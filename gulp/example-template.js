// Gulp tasks related to creating derived example files and updating example
// files from stagehand templates.
'use strict';

module.exports = function (gulp, plugins, config) {

  const cp = plugins.child_process;
  const EXAMPLES_PATH = config.EXAMPLES_NG_DOC_PATH;
  const gulp_task = plugins.gulp_task;
  const LOCAL_TMP = config.LOCAL_TMP;
  const fs = require("fs");
  const path = plugins.path;
  const replace = plugins.replace;

  const qsPath = path.join(EXAMPLES_PATH, 'quickstart');
  const toh0Path = path.join(EXAMPLES_PATH, 'toh-0');

  // Stagehand related tasks (currently outdated)

  const exRootDir = path.resolve(EXAMPLES_PATH, '..');
  const webSimpleProjPath = config.webSimpleProjPath;
  const findCmd = `find ${exRootDir} -type f ! -path "*/node_modules/*" ! -path "*/.*" ! -path "*/build/*" -name pubspec.yaml`;
  let exDirs = (cp.execSync(findCmd) + '').split(/\s+/);
  exDirs = exDirs.map(p => p.replace('/pubspec.yaml', ''));

  gulp.task('_update-ex-analysis-optn',
    () => {
      const baseDir = webSimpleProjPath;
      // plugins.myLog(`exDirs: ${exDirs}`);
      let stream = gulp.src(`${baseDir}/analysis_options.yaml`, { base: baseDir });
      exDirs.forEach(d => {
        stream = stream.pipe(gulp.dest(d));
      });
      return stream;
    });

  gulp_task('update-example-template-files', ['get-stagehand-proj', '_update-ex-analysis-optn']);

  // toh-0

  gulp.task('update-toh-0', () => {
    const baseDir = qsPath;
    return gulp.src([
      `${baseDir}/**`,
      `!${baseDir}/pubspec.lock`,
      `!${baseDir}/build`,
      `!${baseDir}/build/**`,
    ], { base: baseDir })
      // pubspec.yaml
      .pipe(replace(/^(name:) .*$/m, '$1 angular_tour_of_heroes'))
      .pipe(replace(/(^description:).*$/m, '$1 Tour of Heroes'))
      .pipe(replace(/^#(author|homepage).*\n/gm, ''))
      // index.html
      .pipe(replace(/(<title>)[^<]+(<\/title>)/, '$1Angular Tour of Heroes$2'))
      // *.dart
      .pipe(replace(/(package:angular)_app\b/, '$1_tour_of_heroes'))
      // E2E
      .pipe(replace(/E2E Tests/, 'Tutorial $&'))

      .pipe(gulp.dest(toh0Path));
  });

};

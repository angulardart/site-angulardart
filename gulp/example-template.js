// Gulp tasks related to creating derived example files and updating example
// files from stagehand templates.
'use strict';

module.exports = function (gulp, plugins, config) {

  const cp = plugins.child_process;
  const EXAMPLES_PATH = config.EXAMPLES_PATH;
  const LOCAL_TMP = config.LOCAL_TMP;
  const fs = require("fs");
  const path = plugins.path;
  const replace = plugins.replace;

  const qsPath = path.join(EXAMPLES_PATH, 'quickstart');
  const toh0Path = path.join(LOCAL_TMP, EXAMPLES_PATH, 'toh-0');

  // Stagehand related tasks (currently outdated)

  const exRootDir = path.resolve(EXAMPLES_PATH, '..');
  const webSimpleProjPath = config.webSimpleProjPath;
  const findCmd = `find ${exRootDir} -type f ! -path "**/node_modules/**" ! -path "**/.*" ! -path "**/build/**" -name pubspec.yaml`;
  let exDirs = (cp.execSync(findCmd) + '').split(/\s+/);
  exDirs = exDirs.map(p => p.replace('/pubspec.yaml', ''));

  gulp.task('update-example-template-files', ['update-web-simple', '_update-ex-analysis-optn']);

  gulp.task('_update-ex-analysis-optn', //['update-web-simple'],
    (cb) => {
      const baseDir = webSimpleProjPath;
      // plugins.gutil.log(`exDirs: ${exDirs}`);
      let stream = gulp.src(`${baseDir}/analysis_options.yaml`, { base: baseDir });
      exDirs.forEach(d => {
        stream = stream.pipe(gulp.dest(d));
      });
      return stream;
    });

  // toh-0 setup

  const toh0Files='*.yaml lib test web'

  gulp.task('create-toh-0', ['_create-toh-0'], () => {
    plugins.gutil.log(`Making files in ${toh0Path} read-only.`)
    // cp.execSync(`chmod -R -w ${toh0Files}`, { cwd: toh0Path });
  });

  gulp.task('_create-toh-0', cb => {
    const baseDir = qsPath;
    // if (fs.existsSync(toh0Path)) cp.execSync(`chmod -R +w ${toh0Files}`, { cwd: toh0Path });
    return gulp.src([
      `${baseDir}/**`,
      `!${baseDir}/.*`,
      `!${baseDir}/.*/**`,
      `!${baseDir}/build`,
      `!${baseDir}/build/**`,
      `!${baseDir}/example-config.json`,
      `!${baseDir}/e2e-spec.ts`,
    ], { base: baseDir })
      // pubspec.yaml
      .pipe(replace(/^(name:) .*$/m, '$1 angular_tour_of_heroes'))
      .pipe(replace(/(^description:).*$/m, '$1 Tour of Heroes'))
      .pipe(replace(/^#(author|homepage).*\n/gm, ''))
      // index.html
      .pipe(replace(/(<title>)[^<]+(<\/title>)/, '$1Angular Tour of Heroes$2'))
      // *.dart
      .pipe(replace(/(package:angular)_quickstart\b/, '$1_tour_of_heroes'))
      .pipe(gulp.dest(toh0Path));
  });

};

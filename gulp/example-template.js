// Gulp tasks related to updating example template files.
'use strict';

module.exports = function (gulp, plugins, config) {

  const cp = plugins.child_process;
  const EXAMPLES_PATH = config.EXAMPLES_PATH;
  const path = plugins.path;
  const replace = plugins.replace;

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

};

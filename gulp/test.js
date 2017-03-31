// Gulp tasks related to setting up and running angular_test based tests.
'use strict';

module.exports = function (gulp, plugins, config) {

  const EXAMPLES_PATH = config.EXAMPLES_PATH;
  const path = plugins.path;

  const runAngularTest = 'pub run angular_test';

  gulp.task('test', cb => {
    const exPath = path.join(EXAMPLES_PATH, 'toh-0');
    plugins.execp('pub get', { cwd: exPath })
      .then(() => plugins.execp(runAngularTest, { cwd: exPath }))
      .catch(function (err) {
        plugins.gutil.log(`Error running tests. Cmd exit code: ${err}`);
        process.exitCode = err;
      });
  });

};

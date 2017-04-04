// Gulp tasks related to setting up and running angular_test based tests.
'use strict';

module.exports = function (gulp, plugins, config) {

  const path = plugins.path;
  // TODO: change global EXAMPLES_PATH to refer to this too:
  const EXAMPLES_PATH = path.join(config.EXAMPLES_PATH, '..', '..');
  const DOC_EXAMPLES_PATH = config.EXAMPLES_PATH;

  const runAngularTest = 'pub run angular_test';

  gulp.task('test', ['_test-ng-doc', '_test-ng-test']);

  gulp.task('_test-ng-doc', cb => {
    const exPath = path.join(DOC_EXAMPLES_PATH, 'toh-0');
    return pubGetAndRunTest(exPath);
  });

  gulp.task('_test-ng-test', cb => {
    const exPath = path.join(EXAMPLES_PATH, 'ng_test', 'github_issues');
    return pubGetAndRunTest(exPath);
  });

  function pubGetAndRunTest(exPath) {
    return plugins.execp('pub get', { cwd: exPath })
      .then(() => plugins.execp(runAngularTest, { cwd: exPath }))
      .catch(function (err) {
        plugins.gutil.log(`Error running tests. Cmd exit code: ${err}`);
        process.exitCode = err;
      });

  }
};

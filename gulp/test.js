// Gulp tasks related to setting up and running angular_test based tests.
'use strict';

module.exports = function (gulp, plugins, config) {

  const path = plugins.path;
  // TODO: change global EXAMPLES_PATH to refer to this too:
  const EXAMPLES_PATH = path.join(config.EXAMPLES_PATH, '..', '..');
  const DOC_EXAMPLES_PATH = config.EXAMPLES_PATH;

  // Since we are still using content-shell, then it doesn't matter which web compiler we use
  // but we'll still honor the WEB_COMPILER setting.
  const wc = process.env.WEB_COMPILER || 'dart2js'; // vs 'dartdevc'
  const runAngularTest = 'pub run angular_test'
    + ` --serve-arg=--web-compiler=${wc}`
    + ' --test-arg=--platform=content-shell';

  const docEx = ('quickstart template-syntax '
    + 'toh-0 toh-1 toh-2 toh-3 toh-4 toh-5 toh-6').split(' ');

  const docExStatus = { passed: [], failed: [], skipped: [] };

  gulp.task('test', ['_test-ng-doc', '_test-ng-test'], (cb) => {
    plugins.gutil.log(`Passed:\n  ${docExStatus.passed.join('\n  ')}\n`);
    plugins.gutil.log(`Skipped:\n  ${docExStatus.skipped.join('\n  ')}\n`);
    plugins.gutil.log(`Failed:\n  ${docExStatus.failed.join('\n  ')}\n`);
    process.exitCode = docExStatus.failed.length;
  });

  gulp.task('_test-ng-doc', ['create-toh-0'], cb => {
    var promise = Promise.resolve(true);
    docEx.forEach(dir => promise = promise.then(() => {
      plugins.gutil.log(`Running tests for ${dir}`);
      let exPathPrefix = DOC_EXAMPLES_PATH;
      if (dir == 'toh-0') exPathPrefix = path.join(config.LOCAL_TMP, exPathPrefix);
      return pubGetAndRunTest(path.join(exPathPrefix, dir));
    }))
    return promise;
  });

  gulp.task('_test-ng-test', cb => {
    const exPath = path.join(EXAMPLES_PATH, 'ng_test', 'github_issues');
    return pubGetAndRunTest(exPath);
  });

  function pubGetAndRunTest(exPath) {
    return plugins.execp('pub get', { cwd: exPath })
      .then(() => plugins.execp(runAngularTest, { cwd: exPath }))
      .then(() => docExStatus.passed.push(exPath))
      .catch(function (err) {
        plugins.gutil.log(`Error running tests. Cmd exit code: ${err}\n`);
        docExStatus.failed.push(exPath);
      });

  }
};

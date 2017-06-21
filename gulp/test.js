// Gulp tasks related to setting up and running angular_test based tests.
'use strict';

module.exports = function (gulp, plugins, config) {

  const argv = plugins.argv;
  const path = plugins.path;
  // TODO: change global EXAMPLES_PATH to refer to this too:
  const EXAMPLES_PATH = path.join(config.EXAMPLES_PATH, '..', '..');

  // Since we are still using content-shell, then it doesn't matter which web compiler we use
  // but we'll still honor the WEB_COMPILER setting.
  const wc = process.env.WEB_COMPILER || 'dart2js'; // vs 'dartdevc'
  const runAngularTest = 'pub run angular_test'
    + ` --serve-arg=--web-compiler=${wc}`
    + ' --test-arg=--platform=content-shell';

  const pathOfExamplesToTest = ('quickstart template-syntax '
    + 'toh-0 toh-1 toh-2 toh-3 toh-4 toh-5 toh-6').split(' ')
    .map(name => path.join('ng', 'doc', name))
    .concat(path.join('ng_test', 'github_issues'))
    .filter(name => !argv.filter || name.match(new RegExp(argv.filter)));

  const testStatus = { passed: [], failed: [], skipped: [] };

  gulp.task('test', ['_test'], (cb) => {
    plugins.gutil.log(`Passed:\n  ${testStatus.passed.join('\n  ')}\n`);
    plugins.gutil.log(`Skipped:\n  ${testStatus.skipped.join('\n  ')}\n`);
    plugins.gutil.log(`Failed:\n  ${testStatus.failed.join('\n  ')}\n`);
    process.exitCode = testStatus.failed.length;
  });

  gulp.task('_test', cb => {
    var promise = Promise.resolve(true);
    pathOfExamplesToTest.forEach(ex => promise = promise.then(() => {
      plugins.gutil.log(`Running tests for ${ex}`);
      return pubGetAndRunTest(path.join(EXAMPLES_PATH, ex));
    }))
    return promise;
  });

  gulp.task('__list-tests', () => {
    plugins.gutil.log(`tests:\n  ${pathOfExamplesToTest.join('\n  ')}`)
  });

  function pubGetAndRunTest(exPath) {
    return plugins.execp('pub get', { cwd: exPath })
      .then(() => plugins.execp(runAngularTest, { cwd: exPath }))
      .then(() => testStatus.passed.push(exPath))
      .catch(function (err) {
        plugins.gutil.log(`Error running tests. Cmd exit code: ${err}\n`);
        testStatus.failed.push(exPath);
      });

  }
};

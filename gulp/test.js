// Gulp tasks related to setting up and running angular_test based tests.
'use strict';

module.exports = function (gulp, plugins, config) {

  const argv = plugins.argv;
  const path = plugins.path;
  const EXAMPLES_PATH = config.EXAMPLES_ROOT;

  const chooseRegEx = argv.filter || '.';
  const skipRegEx = argv.skip || null;

  // Since we are still using content-shell, then it doesn't matter which web compiler we use
  // but we'll still honor the WEB_COMPILER setting.
  const wc = process.env.WEB_COMPILER || 'dart2js'; // vs 'dartdevc'
  const runAngularTest = 'pub run angular_test'
    + ` --serve-arg=--web-compiler=${wc}`
    + ' --test-arg=--platform=content-shell --test-arg=--tags=aot'
    + ' --test-arg=--reporter=expanded'
    + ' --verbose';

  const allExamplesWithTests = ('quickstart ' +
    'toh-0 toh-1 toh-2 toh-3 toh-4 toh-5 toh-6 ' +
    'template-syntax').split(' ')
    .map(name => path.join('ng', 'doc', name))
    .concat(path.join('ng_test', 'github_issues'));

  const testStatus = {
    passed: [],
    failed: [],
    skipped: allExamplesWithTests.filter(p => p.match(skipRegEx))
  };

  const examplesToTest = allExamplesWithTests
    .filter(p => !p.match(skipRegEx))
    .filter(p => p.match(chooseRegEx));

  gulp.task('test', ['_test'], () => {
    plugins.gutil.log(`Passed:\n  ${testStatus.passed.join('\n  ')}\n`);
    plugins.gutil.log(`Skipped:\n  ${testStatus.skipped.join('\n  ')}\n`);
    plugins.gutil.log(`Failed:\n  ${testStatus.failed.join('\n  ')}\n`);
    process.exitCode = testStatus.failed.length;
  });

  gulp.task('_test', ['_list-tests'], () => {
    var promise = Promise.resolve(true);
    examplesToTest.forEach(ex => promise = promise.then(() => {
      plugins.gutil.log(`Running tests for ${ex}`);
      return pubGetAndRunTest(path.join(EXAMPLES_PATH, ex));
    }));
    return promise;
  });

  gulp.task('_list-tests', () => {
    plugins.gutil.log(`tests:\n  ${examplesToTest.join('\n  ')}`)
  });

  function pubGetAndRunTest(exPath) {
    return plugins.execp(`pub ${config.exAppPubGetOrUpgradeCmd}`, { cwd: exPath })
      .then(() => plugins.execp(runAngularTest, { cwd: exPath }))
      .then(() => testStatus.passed.push(exPath))
      .catch(function (err) {
        plugins.gutil.log(`Error running tests. Cmd exit code: ${err}\n`);
        testStatus.failed.push(exPath);
      });

  }
};

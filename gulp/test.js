// Gulp tasks related to setting up and running angular_test based tests.
'use strict';

module.exports = function (gulp, plugins, config) {

  const argv = plugins.argv;
  const path = plugins.path;
  const EXAMPLES_PATH = config.EXAMPLES_ROOT;

  const chooseRegEx = argv.filter || '.';
  const skipRegEx = argv.skip || null;

  const runHtmlTest = 'pub run test -p travischrome --tags browser';
  const runAngularTest = [
    'pub run build_runner test',
    '--delete-conflicting-outputs',
    plugins.buildWebCompilerOptions(),
    '--',
    '-p chrome',
  ].join(' ');

  const allExamplesWithTests = ('quickstart ' +
    'toh-0 toh-1 toh-2 toh-3 toh-4 toh-5 toh-6 ' +
    'template-syntax').split(' ')
    .map(name => path.join('ng', 'doc', name))
    .concat('html');

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
    const status = testStatus.failed.length;
    process.exitCode = status;
    // Sometimes the process doesn't exit, or not quickly enough, so throw.
    if (status) throw status;
  });

  gulp.task('_test', ['_list-tests'], async () => {
    for (var ex of examplesToTest) {
      plugins.gutil.log(`START COMPONENT TESTING for ${ex}`);
      await pubGetAndRunTest(path.join(EXAMPLES_PATH, ex));
    }
  });

  gulp.task('_list-tests', () => {
    plugins.gutil.log(`tests:\n  ${examplesToTest.join('\n  ')}`)
  });

  async function pubGetAndRunTest(exPath) {
    try {
      await plugins.execp(`pub ${config.exAppPubGetOrUpgradeCmd}`, { cwd: exPath });
      // plugins.generateBuildYaml(exPath);
      const runTest = exPath === 'examples/html' ? runHtmlTest : runAngularTest;
      await plugins.execp(runTest, {
        cwd: exPath,
        okOnExitRE: /All tests passed/,
        errorOnExitRE: /\[SEVERE\]|\[WARNING\](?! (\w+: )?(Invalidating|Throwing away cached) asset graph)/,
      });
      testStatus.passed.push(exPath);
    } catch (e) {
      plugins.gutil.log(`Error running tests: ${e}\n`);
      testStatus.failed.push(exPath);
    }
  }
};

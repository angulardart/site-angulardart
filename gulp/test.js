// Gulp tasks related to setting up and running angular_test based tests.
'use strict';

module.exports = function (gulp, plugins, config) {

  const argv = plugins.argv;
  const path = plugins.path;
  const EXAMPLES_PATH = config.EXAMPLES_ROOT;

  const chooseRegEx = argv.filter || '.';
  const skipRegEx = argv.skip || null;

  const webdevBuild = 'pub global run webdev build --no-release';
  const runHtmlTest = 'pub run test -p chrome --tags browser';
  const runAngularTest = [
    'pub run build_runner test',
    '--delete-conflicting-outputs',
    plugins.buildWebCompilerOptions(),
    '--',
    '-p chrome',
  ].join(' ');

  const allExamplesWithTests = `quickstart
      toh-0 toh-1 toh-2 toh-3 toh-4 toh-5 toh-6
      template-syntax`.split(/\s+/)
    .map(name => path.join('ng', 'doc', name))
    // .concat(['fetch_data', 'html'])
    .concat(['1-base', '2-starteasy', '3-usebuttons', '4-final']
      .map(name => path.join('acx', 'lottery', name)))
    .concat(['ng/api/common/pipes', 'ng/api/core/ngzone'])
    .sort();

  const testStatus = {
    passed: [],
    failed: [],
    skipped: allExamplesWithTests.filter(p => p.match(skipRegEx))
  };

  const examplesToTest = allExamplesWithTests
    .filter(p => !p.match(skipRegEx))
    .filter(p => p.match(chooseRegEx));

  function _list_tests() { plugins.myLog(`tests:\n  ${examplesToTest.join('\n  ')}`); }

  async function _test() {
      _list_tests();
      for (var ex of examplesToTest) {
        plugins.myLog(`START COMPONENT TESTING for ${ex}`);
        await pubGetAndRunTest(path.join(EXAMPLES_PATH, ex));
      }
  }

  async function test() {
    await _test();
    plugins.myLog(`Passed:\n  ${testStatus.passed.join('\n  ')}\n`);
    plugins.myLog(`Skipped:\n  ${testStatus.skipped.join('\n  ')}\n`);
    plugins.myLog(`Failed:\n  ${testStatus.failed.join('\n  ')}\n`);
    const status = testStatus.failed.length;
    process.exitCode = status;
    // Sometimes the process doesn't exit, or not quickly enough, so throw.
    if (status) throw status;
  }

  gulp.task('_list-tests', _list_tests);
  gulp.task('_test', _test);
  gulp.task('test', test);

  function onlyBuild(path) {
    return path.startsWith('examples/ng/api') || path.startsWith('examples/fetch_data');
  }

  async function pubGetAndRunTest(exPath) {
    try {
      await plugins.execp(`pub ${config.exAppPubGetOrUpgradeCmd}`, { cwd: exPath });

      // plugins.generateBuildYaml(exPath);
      const runTest =
        exPath === 'examples/html' ? runHtmlTest
          : onlyBuild(exPath) ? webdevBuild :
            runAngularTest;
      await plugins.execp(runTest, {
        cwd: exPath,
        okOnExitRE: onlyBuild(exPath) ? '' : /All tests passed/,
        errorOnExitRE: /\[SEVERE\]|\[WARNING\](?! (\w+: )?(Invalidating|Throwing away cached) asset graph)/,
      });

      await plugins.execp('dartanalyzer --fatal-warnings .', { cwd: exPath });

      testStatus.passed.push(exPath);
    } catch (e) {
      plugins.myLog(`Error preparing for or running tests: ${e}\n`);
      testStatus.failed.push(exPath);
    }
  }
};

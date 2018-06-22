// Gulp tasks related to setting up and running e2e tests.
'use strict';

module.exports = function (gulp, plugins, config) {

  const _ = require('lodash');

  const argv = plugins.argv;
  const copyFiles = plugins.copyFiles;
  const fs = plugins.fs;
  const fsExtra = fs;
  const gutil = plugins.gutil;
  const path = plugins.path;
  const pexec = plugins.pexec;
  const Q = plugins.q;
  const replace = plugins.replace;
  const spawnExt = plugins.spawnExt;
  const treeKill = require('tree-kill');

  const EXAMPLES_PATH = config.EXAMPLES_NG_DOC_PATH;
  const EXAMPLES_TESTING_PATH = path.join(EXAMPLES_PATH, 'testing/ts');
  const TOOLS_PATH = config.TOOLS_PATH;

  let skipRegEx = argv.skip;
  let skippedExPaths = [];

  const lang='dart';

  // ==========================================================================
  // Tasks and helper functions for running e2e
  // TODO: move this to a separate task file.

  // Run protractor end-to-end specs
  gulp.task('e2e', runE2e);

  /**
   * Run Protractor End-to-End Tests for Doc Samples
   *
   * Flags
   *   --filter regex, will only run E2E on example paths matching regex
   *   --skip regex, will not run E2E on matching example paths
   *   --fast by-passes the npm install and webdriver update
   *     Use it for repeated test runs, but not the FIRST run.
   */
  async function runE2e() {
    if (!argv.fast) {
      // Do full setup
      await pexec('npm install', { cwd: EXAMPLES_PATH });
      buildStyles(copyExampleBoilerplate, _.noop);
      gutil.log('runE2e: update webdriver');
      await pexec('npm run webdriver:update', { cwd: EXAMPLES_PATH });
    };
    const outputFile = path.join(process.cwd(), 'protractor-results.txt');
    const status = await findAndRunE2eTests(argv.filter, outputFile);
    reportStatus(status, outputFile);
    if (status.failed.length > 0) throw 'Some test suites failed';
  }

  // finds all of the *e2e-spec.tests under the _examples folder along
  // with the corresponding apps that they should run under. Then run
  // each app/spec collection sequentially.
  async function findAndRunE2eTests(filter, outputFile) {
    // create an output file with header.
    var startTime = new Date().getTime();
    var header = `Doc Sample Protractor Results for ${lang} on ${new Date().toLocaleString()}\n`;
    header += argv.fast ?
      '  Fast Mode (--fast): no npm install, webdriver update, or boilerplate copy\n' :
      '  Slow Mode: npm install, webdriver update, and boilerplate copy\n';
    header += `  Filter: ${filter ? filter : 'All tests'}\n\n`;
    fs.writeFileSync(outputFile, header);

    var e2eSpecPaths = plugins.globby.sync([
      `${EXAMPLES_PATH}/**/*e2e-spec.*`,
      `!**/.*/**`, // No need to search inside dot folders
      `!**/node_modules/**`, // should be no node_module, but just in case.
    ]);

    // Do negative filter first (remove what we don't want):
    if (skipRegEx) {
      skippedExPaths = e2eSpecPaths.filter(p => p.match(skipRegEx));
      e2eSpecPaths = e2eSpecPaths.filter(p => !p.match(skipRegEx));
    }
    // Then do positive filter (keep what we want):
    if (filter) e2eSpecPaths = e2eSpecPaths.filter(p => p.match(filter));

    // At the moment, all spec files are just below the project root,
    // and there is at most one spec file (which means there are no duplicates):
    var examplePaths = e2eSpecPaths.map(p => path.dirname(p));

    gutil.log(`\nE2E scheduled to run:\n  ${examplePaths.join('\n  ')}`);
    gutil.log(`\nE2E skipping:\n  ${skippedExPaths.join('\n  ')}`);

    var status = { passed: [], failed: [] };
    for (var examplePath of examplePaths) {
      const passed = await runExampleE2E(examplePath, outputFile);
      const list = passed ? status.passed : status.failed;
      list.push(examplePath);
    }
    var stopTime = new Date().getTime();
    status.elapsedTime = (stopTime - startTime)/1000;
    return status;
  }

  // start the server in appDir/build/web; then run protractor with the specified
  // fileName; then shut down the example.  All protractor output is appended
  // to the outputFile.
  async function runExampleE2E(appDir, outputFile) {
    gutil.log(`E2E for ${appDir}`);

    const deployDir = path.resolve(appDir, 'build/web');
    const appRunSpawnInfo = spawnExt('npm', ['run', 'http-server', '--', deployDir, '-s'], { cwd: appDir });
    if (!appRunSpawnInfo.proc.pid) {
      const msg = `http-server failed to launch over ${deployDir}`;
      gutil.log(msg);
      throw new Error(msg);
    }

    try {
      // Build app
      if (argv.pub === false) {
        gutil.log(`Skipping pub ${config.exAppPubGetOrUpgradeCmd} and pub build (--no-pub flag present)`);
      } else {
        await pexec(`pub ${config.exAppPubGetOrUpgradeCmd}`, { cwd: appDir });
        // plugins.generateBuildYaml(appDir);
        // webdev don't always play nice if the output dir exists so delete it if present:
        if (fs.existsSync(path.join(appDir, 'build'))) await plugins.execp('rm -Rf build', { cwd: appDir });
        let buildOpts = plugins.buildWebCompilerOptions();
        if (fs.existsSync(path.join(appDir, 'build.no_test.yaml'))) buildOpts += ' --config=no_test';
        await pexec(`pub global run webdev build ${buildOpts}`, {
          cwd: appDir,
          log: gutil.log,
          okOnExitRE: /\[INFO\]( Build:)? Succeeded/,
          errorOnExitRE: /\[SEVERE\]|\[WARNING\](?! (\w+: )?(Invalidating asset graph|Throwing away cached asset graph|No actions completed for ))/,
        });
      }
      await pexec(
        `npm run protractor -- protractor.config.js` +
        ` --specs=${path.resolve(appDir, 'e2e-spec.ts')} --params.appDir=${appDir}` +
        ` --params.outputFile=${outputFile}`,
        { cwd: EXAMPLES_PATH, log: gutil.log, },
      );
      return true;
    } catch (e) {
      gutil.log(`runExampleE2E over ${appDir} failed.`);
      throw e;
    } finally {
      // appRun.proc.kill(); // does not work properly on windows with child processes.
      treeKill(appRunSpawnInfo.proc.pid);
    }
    return false;
  }

  function reportStatus(status, outputFile) {
    var log = [''];
    log.push('Suites passed:');
    status.passed.forEach(function(val) {
      log.push('  ' + val);
    });

    if (status.failed.length == 0) {
      log.push('All tests passed');
    } else {
      log.push('Suites failed:');
      status.failed.forEach(function (val) {
        log.push('  ' + val);
      });
    }
    log.push('\nElapsed time: ' +  status.elapsedTime + ' seconds');
    var log = log.join('\n');
    log += `\nE2E skipped:\n  ${skippedExPaths.join('\n  ')}`;
    gutil.log(log);
    fs.appendFileSync(outputFile, log);
  }

};

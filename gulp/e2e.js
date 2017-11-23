// Gulp tasks related to setting up and running e2e tests.
'use strict';

module.exports = function (gulp, plugins, config) {

  const less = require('gulp-less');
  const _ = require('lodash');

  const argv = plugins.argv;
  const cp = plugins.child_process;
  const execp = plugins.execp;
  const fs = plugins.fs;
  const fsExtra = fs;
  const gutil = plugins.gutil;
  const path = plugins.path;
  const replace = plugins.replace;
  const spawnExt = plugins.spawnExt;
  const Q = plugins.q;
  const copyFiles = plugins.copyFiles;

  const EXAMPLES_PATH = config.EXAMPLES_NG_DOC_PATH;
  const EXAMPLES_TESTING_PATH = path.join(EXAMPLES_PATH, 'testing/ts');
  const BOILERPLATE_PATH = path.join(EXAMPLES_PATH, '_boilerplate');
  const TOOLS_PATH = config.TOOLS_PATH;
  // const STYLES_SOURCE_PATH = path.join(TOOLS_PATH, 'styles-builder/less');

  let skipRegEx = argv.skip;
  let skippedExPaths = [];

  const lang='dart';

  var _exampleBoilerplateFiles = [
    // Only the *.css files were needed for Dart.
    // but they are handled via _exampleDartWebBoilerPlateFiles.
  ];

  var _exampleDartWebBoilerPlateFiles = [/*'a2docs.css',*/'favicon.png', 'styles.css'];

  var _exampleUnitTestingBoilerplateFiles = [
    'browser-test-shim.js',
    'karma-test-shim.js',
    'karma.conf.js'
  ];

  var _exampleConfigFilename = 'example-config.json';

  const _styleLessName = 'a2docs.less';


  gulp.task('add-example-boilerplate', function(done) {
    // var realPath = path.join(EXAMPLES_PATH, '/node_modules');
    // var nodeModulesPaths = excludeDartPaths(getNodeModulesPaths(EXAMPLES_PATH));
    // nodeModulesPaths.forEach(function(linkPath) {
    //   gutil.log("symlinking " + linkPath + ' -> ' + realPath)
    //   fsUtils.addSymlink(realPath, linkPath);
    // });
    return argv.fast ? done() : buildStyles(copyExampleBoilerplate, done);
  });

  //Builds Angular Docs CSS file from Bootstrap npm LESS source
  //and copies the result to the _examples folder to be included as
  //part of the example boilerplate.
  function buildStyles(cb, done){
    // 2017-03-05: Stop building a2docs.css file
    /*
    gulp.src(path.join(STYLES_SOURCE_PATH, _styleLessName))
      .pipe(less())
      .pipe(gulp.dest(BOILERPLATE_PATH)).on('end', function(){
        cb().then(function() { done(); });
      });
    */
    cb().then(function() { done(); });
  }

  // copies boilerplate files to locations
  // where an example app is found
  // also copies certain web files (e.g., styles.css) to web
  function copyExampleBoilerplate() {
    gutil.log('Copying example boilerplate files');
    var sourceFiles = _exampleBoilerplateFiles.map(function(fn) {
      return path.join(BOILERPLATE_PATH, fn);
    });
    var examplePaths = excludeDartPaths(getExamplePaths(EXAMPLES_PATH));

    var dartWebSourceFiles = _exampleDartWebBoilerPlateFiles.map(function(fn){
      return path.join(BOILERPLATE_PATH, fn);
    });
    var dartExampleWebPaths = getDartExampleWebPaths(EXAMPLES_PATH);

    // Make boilerplate files read-only to avoid that they be edited by mistake.
    var destFileMode = '444';
    return copyFiles(sourceFiles, examplePaths, destFileMode)
      .then(function() {
        return copyFiles(dartWebSourceFiles, dartExampleWebPaths, destFileMode);
      })
      // copy the unit test boilerplate
      .then(function() {
        var unittestSourceFiles =
          _exampleUnitTestingBoilerplateFiles
            .map(function(name) { return path.join(EXAMPLES_TESTING_PATH, name); });
        var unittestPaths = getUnitTestingPaths(EXAMPLES_PATH);
        return copyFiles(unittestSourceFiles, unittestPaths, destFileMode);
      })
      .catch(function(err) {
        gutil.log(err);
        throw err;
      });
  }

  gulp.task('remove-example-boilerplate', function() {
    // var nodeModulesPaths = getNodeModulesPaths(EXAMPLES_PATH);
    // nodeModulesPaths.forEach(function(linkPath) {
    //   fsUtils.removeSymlink(linkPath);
    // });
    deleteExampleBoilerPlate();
  });

  function isDartPath(path) { return true; }

  function excludeDartPaths(paths) {
    return paths.filter(function (p) { return !isDartPath(p); });
  }

  function getExamplePaths(basePath, includeBase) {
    // includeBase defaults to false
    return getPaths(basePath, _exampleConfigFilename, includeBase);
  }

  function getDartExampleWebPaths(basePath) {
    return plugins.globby.sync([path.join(basePath, '**/web')]);
  }

  function getUnitTestingPaths(basePath) {
    var examples = getPaths(basePath, _exampleConfigFilename, true);
    return examples.filter((example) => {
      var exampleConfig = fs.readJsonSync(`${example}/${_exampleConfigFilename}`, {throws: false});
      return exampleConfig && !!exampleConfig.unittesting;
    });
  }

  function getPaths(basePath, filename, includeBase) {
    var filenames = getFilenames(basePath, filename, includeBase);
    var paths = filenames.map(function(fileName) {
      return path.dirname(fileName);
    });
    return paths;
  }

  function getFilenames(basePath, filename, includeBase) {
    // includeBase defaults to false
    var includePatterns = [path.join(basePath, "**/" + filename)];
    if (!includeBase) {
      // ignore (skip) the top level version.
      includePatterns.push("!" + path.join(basePath, "/" + filename));
    }
    // ignore (skip) the files in BOILERPLATE_PATH.
    includePatterns.push("!" + path.join(BOILERPLATE_PATH, "/" + filename));
    var nmPattern = path.join(basePath, "**/node_modules/**");
    var filenames = plugins.globby.sync(includePatterns, {ignore: [nmPattern]});
    return filenames;
  }

  // deletes boilerplate files that were added by copyExampleBoilerplate
  // from locations where an example app is found
  gulp.task('delete-example-boilerplate', deleteExampleBoilerPlate);

  function deleteExampleBoilerPlate() {
    gutil.log('Deleting example boilerplate files');
    var examplePaths = getExamplePaths(EXAMPLES_PATH);
    var dartExampleWebPaths = getDartExampleWebPaths(EXAMPLES_PATH);
    var unittestPaths = getUnitTestingPaths(EXAMPLES_PATH);

    return deleteFiles(_exampleBoilerplateFiles, examplePaths)
      .then(function() {
        return deleteFiles(_exampleDartWebBoilerPlateFiles, dartExampleWebPaths);
      })
      .then(function() {
        return deleteFiles(_exampleUnitTestingBoilerplateFiles, unittestPaths);
      });
  }

  function deleteFiles(baseFileNames, destPaths) {
    var remove = Q.denodeify(fsExtra.remove);
    var delPromises = [];
    destPaths.forEach(function(destPath) {
      baseFileNames.forEach(function(baseFileName) {
        var destFileName = path.join(destPath, baseFileName);
        var p = remove(destFileName);
        delPromises.push(p);
      });
    });
    return Q.all(delPromises);
  }

  // ==========================================================================
  // Tasks and helper functions for running e2e
  // TODO: move this to a separate task file.

  var treeKill = require("tree-kill");

  /**
   * Run Protractor End-to-End Specs for Doc Samples
   * Alias for 'run-e2e-tests'
   */
  gulp.task('e2e', (cb) => runE2e());

  gulp.task('run-e2e-tests', (cb) => runE2e());

  /**
   * Run Protractor End-to-End Tests for Doc Samples
   *
   * Flags
   *   --filter to filter/select _example app subdir names
   *    e.g. gulp e2e --filter=foo  // all example apps with 'foo' in their folder names.
   *
   *    --fast by-passes the npm install and webdriver update
   *    Use it for repeated test runs (but not the FIRST run)
   *    e.g. gulp e2e --fast
   *
   *   --lang to filter by code language (see above for details)
   *     e.g. gulp e2e --lang=ts  // only TypeScript apps
   */
  function runE2e() {
    // const skipList = skipRegEx ? [skipRegEx] : [];
    // // https://github.com/dart-lang/site-webdev/issues/703
    // if (process.env.WEB_COMPILER === 'dartdevc') {
    //   skipList.push('toh-[56]|lifecycle-hooks');
    // }
    // skipRegEx = skipList.join('|');

    var promise;
    if (argv.fast) {
      // fast; skip all setup
      promise = Promise.resolve(true);
    } else  {
      /*
        // Not 'fast'; do full setup
      var spawnInfo = spawnExt('npm', ['install'], { cwd: EXAMPLES_PATH});
      promise = spawnInfo.promise.then(function() {
        copyExampleBoilerplate();
        spawnInfo = spawnExt('npm', ['run', 'webdriver:update'], {cwd: EXAMPLES_PATH});
        return spawnInfo.promise;
      });
      */
      // Not 'fast'; do full setup
      gutil.log('runE2e: install _examples stuff');
      var spawnInfo = spawnExt('npm', ['install'], { cwd: EXAMPLES_PATH});
      promise = spawnInfo.promise
        .then(function() {
          buildStyles(copyExampleBoilerplate, _.noop);
          gutil.log('runE2e: update webdriver');
          spawnInfo = spawnExt('npm', ['run', 'webdriver:update'], {cwd: EXAMPLES_PATH});
          return spawnInfo.promise;
        });
    };

    var outputFile = path.join(process.cwd(), 'protractor-results.txt');

    promise.then(function() {
      return findAndRunE2eTests(argv.filter, outputFile);
    }).then(function(status) {
      reportStatus(status, outputFile);
      if (status.failed.length > 0){
        return Promise.reject('Some test suites failed');
      }
    }).catch(function(e) {
      gutil.log(e);
      process.exitCode = 1;
    });
    return promise;
  }

  // finds all of the *e2e-spec.tests under the _examples folder along
  // with the corresponding apps that they should run under. Then run
  // each app/spec collection sequentially.
  function findAndRunE2eTests(filter, outputFile) {
    // create an output file with header.
    var startTime = new Date().getTime();
    var header = `Doc Sample Protractor Results for ${lang} on ${new Date().toLocaleString()}\n`;
    header += argv.fast ?
      '  Fast Mode (--fast): no npm install, webdriver update, or boilerplate copy\n' :
      '  Slow Mode: npm install, webdriver update, and boilerplate copy\n';
    header += `  Filter: ${filter ? filter : 'All tests'}\n\n`;
    fs.writeFileSync(outputFile, header);

    // create an array of combos where each
    // combo consists of { examplePath: ... }
    var examplePaths = [];
    var e2eSpecPaths = getE2eSpecPaths(EXAMPLES_PATH);

    // Do negative filter first (remove what we don't want):
    if (skipRegEx) {
      skippedExPaths = e2eSpecPaths.filter(p => p.match(skipRegEx));
      e2eSpecPaths = e2eSpecPaths.filter(p => !p.match(skipRegEx));
    }
    // Then do positive filter (keep what we want):
    if (filter) e2eSpecPaths = e2eSpecPaths.filter(p => p.match(filter));

    e2eSpecPaths.forEach(function(specPath) {
      // get all of the examples under each dir where a pcFilename is found
      let localExamplePaths = getExamplePaths(specPath, true);
      examplePaths.push(...localExamplePaths);
    });

    gutil.log(`\nE2E scheduled to run:\n  ${examplePaths.join('\n  ')}`);
    gutil.log(`\nE2E skipping:\n  ${skippedExPaths.join('\n  ')}`);

    // run the tests sequentially
    var status = { passed: [], failed: [] };
    return examplePaths.reduce(function (promise, examplePath) {
      return promise.then(function () {
        var runTests = isDartPath(examplePath) ? runE2eDartTests : runE2eTsTests;
        return runTests(examplePath, outputFile).then(function(ok) {
          var arr = ok ? status.passed : status.failed;
          arr.push(examplePath);
        })
      });
    }, Q.resolve()).then(function() {
      var stopTime = new Date().getTime();
      status.elapsedTime = (stopTime - startTime)/1000;
      return status;
    });
  }

  // start the example in appDir; then run protractor with the specified
  // fileName; then shut down the example.  All protractor output is appended
  // to the outputFile.
  function runE2eTsTests(appDir, outputFile) {
    // throw 'TS tests should not be run';
    // // Grab protractor configuration or defaults to systemjs config.
    // try {
    //   var exampleConfig = fs.readJsonSync(`${appDir}/${_exampleConfigFilename}`);
    // } catch (e) {
    //   exampleConfig = {};
    // }

    // var config = {
    //   build: exampleConfig.build || 'tsc',
    //   run: exampleConfig.run || 'http-server:e2e'
    // };

    // var appBuildSpawnInfo = spawnExt('npm', ['run', config.build], { cwd: appDir });
    // var appRunSpawnInfo = spawnExt('npm', ['run', config.run, '--', '-s'], { cwd: appDir });

    // var run = runProtractor(appBuildSpawnInfo.promise, appDir, appRunSpawnInfo, outputFile);

    // if (fs.existsSync(appDir + '/aot/index.html')) {
    //   run = run.then(() => runProtractorAoT(appDir, outputFile));
    // }
    // return run;
  }

  function runProtractor(prepPromise, appDir, appRunSpawnInfo, outputFile) {
    var specFilename = path.resolve(`${appDir}/e2e-spec.ts`);
    return prepPromise
      .catch(function(){
        var emsg = `Application at ${appDir} failed to transpile.\n\n`;
        gutil.log(emsg);
        fs.appendFileSync(outputFile, emsg);
        return Promise.reject(emsg);
      })
      .then(function (data) {
        var transpileError = false;

        // start protractor

        var spawnInfo = spawnExt('npm', [ 'run', 'protractor', '--', 'protractor.config.js',
          `--specs=${specFilename}`, '--params.appDir=' + appDir, '--params.outputFile=' + outputFile], { cwd: EXAMPLES_PATH });

        spawnInfo.proc.stderr.on('data', function (data) {
          transpileError = transpileError || /npm ERR! Exit status 100/.test(data.toString());
        });
        return spawnInfo.promise.catch(function(err) {
          if (transpileError) {
          var emsg = `${specFilename} failed to transpile.\n\n`;
          gutil.log(emsg);
          fs.appendFileSync(outputFile, emsg);
          }
          return Promise.reject(emsg);
        });
      })
      .then(
        function() { return finish(true);},
        function() { return finish(false);}
      )

      function finish(ok){
        // Ugh... proc.kill does not work properly on windows with child processes.
        // appRun.proc.kill();
        treeKill(appRunSpawnInfo.proc.pid);
        return ok;
      }
  }

  // function runProtractorAoT(appDir, outputFile) {
  //   fs.appendFileSync(outputFile, '++ AoT version ++\n');
  //   var aotBuildSpawnInfo = spawnExt('npm', ['run', 'build:aot'], { cwd: appDir });
  //   var promise = aotBuildSpawnInfo.promise;

  //   var copyFileCmd = 'copy-dist-files.js';
  //   if (fs.existsSync(appDir + '/' + copyFileCmd)) {
  //     promise = promise.then(() =>
  //     spawnExt('node', [copyFileCmd], { cwd: appDir }).promise );
  //   }
  //   var aotRunSpawnInfo = spawnExt('npm', ['run', 'http-server:e2e', 'aot', '--', '-s'], { cwd: appDir });
  //   return runProtractor(promise, appDir, aotRunSpawnInfo, outputFile);
  // }

  // start the server in appDir/build/web; then run protractor with the specified
  // fileName; then shut down the example.  All protractor output is appended
  // to the outputFile.
  function runE2eDartTests(appDir, outputFile) {
    // was: // Launch http server out of ts directory because all the config files are there.
    // was: ar httpLaunchDir = path.resolve(appDir, '../ts');
    var httpLaunchDir = appDir;
    var deployDir = path.resolve(appDir, 'build/web');
    gutil.log('AppDir for Dart e2e: ' + appDir);
    gutil.log('Deploying from: ' + deployDir);

    var appRunSpawnInfo = spawnExt('npm', ['run', 'http-server', '--', deployDir, '-s'], { cwd: httpLaunchDir });
    if (!appRunSpawnInfo.proc.pid) {
      gutil.log('http-server failed to launch over ' + deployDir);
      return false;
    }
    if (argv.pub === false) {
      var prepPromise = Promise.resolve(true);
      gutil.log(`Skipping pub ${config.exAppPubGetOrUpgradeCmd} and pub build (--no-pub flag present)`);
    } else {
      var pubGetSpawnInfo = spawnExt('pub', [config.exAppPubGetOrUpgradeCmd], { cwd: appDir });
      var prepPromise = pubGetSpawnInfo.promise.then(function (data) {
        const wc = process.env.WEB_COMPILER || 'dart2js'; // vs 'dartdevc'
        return spawnExt('pub', ['build', `--web-compiler=${wc}`], { cwd: appDir }).promise;
      });
    }
    return runProtractor(prepPromise, appDir, appRunSpawnInfo, outputFile);
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

  // TODO: filter out all paths that are subdirs of another
  // path in the result.
  function getE2eSpecPaths(basePath) {
    var paths = getPaths(basePath, '*e2e-spec.+(js|ts)', true);
    return _.uniq(paths);
  }

};

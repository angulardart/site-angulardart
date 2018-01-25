// Gulp tasks related to setting up and running e2e tests.
'use strict';

module.exports = function (gulp, plugins, config) {

  const less = require('gulp-less');
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
        await pexec(`pub ${config.exAppPubGetOrUpgradeCmd} --no-precompile`, { cwd: appDir });
        await pexec(`pub build --web-compiler=${argv.webCompiler || 'dart2js'}`, {
          cwd: appDir,
          log: gutil.log,
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

  // TODO: filter out all paths that are subdirs of another
  // path in the result.
  function getE2eSpecPaths(basePath) {
    var paths = getPaths(basePath, '*e2e-spec.+(js|ts)', true);
    return _.uniq(paths);
  }

};

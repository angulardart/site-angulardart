'use strict';

if (!process.env.DART_SITE_ENV_DEFS) {
  const msg = 'Some mandatory environment variables are undefined.\n' +
    'Did you forget to: source ./tool/env-set.sh?';
  console.log(msg);
  throw msg;
}

const gulp = require('gulp');

const argv = require('yargs').argv;
const assert = require('assert-plus');
const child_process = require('child_process');
const chmod = require('gulp-chmod');
const cpExec = child_process.exec;
const del = require('del');
const fsExtra = require('fs-extra');
const fs = fsExtra;
const globby = require("globby");
const imagemin = require('gulp-imagemin');
const path = require('canonical-path');
const { promisify } = require('util');
// const promisifiedExec = promisify(cp.exec); // use pexec
const Q = require("q");
const spawn = child_process.spawn;
const taskListing = require('gulp-task-listing');
// cross platform version of spawn that also works on windows.
const xSpawn = require('cross-spawn');
const yamljs = require('yamljs');

function xExec(cmd_and_args, options) {
  const cmd_and_args_arr = cmd_and_args.split(' ');
  const pp = spawnExt(cmd_and_args_arr[0], cmd_and_args_arr.splice(1), options);
  return pp;
}

const myLog = console.log
const exec = xExec; // cpExec;
const npmbin = path.resolve('node_modules/.bin');
const npmbinMax = `node --max-old-space-size=4096 ${npmbin}`;

const THIS_PROJECT_PATH = path.resolve('.');
const _configYml = yamljs.load('_config.yml');

const siteFolder = _configYml.destination || _throw();

// angular.io constants
const EXAMPLES_ROOT = 'examples';
const EXAMPLES_NG_DOC_PATH = 'examples/ng/doc'; // used to be named EXAMPLES_PATH
const TOOLS_PATH = './tools';
const TMP_PATH = process.env.TMP; // shared temp folder (for larger downloads, etc)
const LOCAL_TMP = 'tmp'; // temp folder local to this project
if (!fs.existsSync(LOCAL_TMP)) fs.mkdirpSync(LOCAL_TMP);

const angularRepoRoot = process.env.NG_REPO;
const angulario = path.resolve('../angular.io');

const isSilent = !!argv.silent;
function noop() { }
if (isSilent) myLog = noop;
// Use --log-at=LEVEL to avoid conflict with the gulp --log-level flag.
const _logLevel = argv.logAt || (isSilent ? 'error' : 'warn');

const source = _configYml.source || _throw();

const ngDocSrc = path.join(source, 'angular');
const ngPkgVersPath = `./${source}/_data/pkg-vers.json`;
const ngPkgVers = require(ngPkgVersPath);
const fragsPath = path.join(LOCAL_TMP, '_fragments');
const qsProjName = 'angular_app';

const config = {
  _dgeniLogLevel: _logLevel,
  _logLevel: _logLevel,
  angulario: angulario,
  dartdoc: 'pub global run dartdoc',
  _dartdocProj: ['acx', 'forms', 'ng', 'router', 'test'],
  dartdocProj: "initialized below",
  exAppPubGetOrUpgradeCmd: 'get', // or 'upgrade', see https://github.com/dart-lang/site-webdev/issues/1195
  EXAMPLES_ROOT: EXAMPLES_ROOT,
  EXAMPLES_NG_DOC_PATH: EXAMPLES_NG_DOC_PATH,
  frags: {
    apiDirName: '_api',
    dirName: path.basename(fragsPath),
    path: fragsPath,
  },
  ghNgEx: _configYml.ghNgEx || _throw(),
  LOCAL_TMP: LOCAL_TMP,
  ngDocSrc: ngDocSrc,
  ngPkgVers: ngPkgVers,
  ngPkgVersPath: ngPkgVersPath,
  qsProjName: qsProjName,
  relDartDocApiDir: path.join('doc', 'api'),
  repoPath: {
    acx: '../angular_components',
    forms: path.join(angularRepoRoot, 'angular_forms'),
    ng: path.join(angularRepoRoot, 'angular'),
    router: path.join(angularRepoRoot, 'angular_router'),
    test: path.join(angularRepoRoot, 'angular_test'),
  },
  siteFolder: siteFolder,
  source: source,
  srcData: path.join(source, '_data'),
  THIS_PROJECT_PATH: THIS_PROJECT_PATH,
  tmpPubPkgsPath: path.join(LOCAL_TMP, 'pub-packages'),
  TOOLS_PATH: TOOLS_PATH,
  unifiedApiPath: path.join(siteFolder, 'api'),
  webSimpleProjPath: path.join(TMP_PATH, qsProjName),
};

const plugins = {
  argv: argv,
  buildWebCompilerOptions: buildWebCompilerOptions,
  child_process: child_process,
  chmod: chmod,
  copyFiles: copyFiles,
  del: del,
  delFv: delFv,
  gulp_task: gulp_task,
  execSyncAndLog: execSyncAndLog,
  execp: execp,
  filter: require('gulp-filter'),
  fs: fs,
  genDartdocForProjs: genDartdocForProjs,
  getPathToApiDir: getPathToApiDir,
  generateBuildYaml: generateBuildYaml,
  gitCheckDiff: gitCheckDiff,
  globby: globby,
  logAndExit1: logAndExit1,
  myLog: myLog,
  path: path,
  pexec: pexec,
  pkgAliasToPkgName: pkgAliasToPkgName,
  q: Q,
  rename: require('gulp-rename'),
  replace: require('gulp-replace'),
  spawnExt: spawnExt,
  stringify: stringify,
  _task: _task,
  yamljs: yamljs,
};

function _isPromise(o) { return Promise.resolve(o) === o; }
function _task(task) { return (done) => {
    const result = task();
    if(_isPromise(result)) {
      throw 'Error: `_task()` applied to a function returning a Promise, '
      + 'possibly through `gulp_task()`.\n'
      + 'If so, use `gulp.task()` directly instead.';
    }
    done();
    return result;
  };
}
function _gulp_tasks(name, _tasks) {
  const tasks = _tasks.map(t => typeof t === 'function' ? _task(t) : t);
  return gulp.task(name, gulp.series.apply(null, tasks));
}
function gulp_task(name, taskOrTasks) {
  // myLog(`>> Defining task ${name}`)
  return typeof taskOrTasks === 'function'
    ? gulp.task(name, _task(taskOrTasks))
    : _gulp_tasks(name, taskOrTasks);
}

config.dartdocProj = null; // genDartdocForProjs(); FIXME: remove function too
assert.deepEqual(config._dartdocProj, Object.keys(config.repoPath));

function pkgAliasToPkgName(alias) {
  switch (alias) {
    case 'ng':
      return 'angular';
    case 'acx':
      alias = 'components';
    // fall through
    default:
      return `angular_${alias}`;
  }
}

function genDartdocForProjs() {
  // Temporarily require a --[no]-dartdoc flag until we get used to the new build task behavior:
  const args = process.argv.slice(2); // Skip nodejs and gulpjs
  if (args.length
    && !args[0].startsWith('-')
    && args.some(arg => arg.startsWith('build'))
    && argv.dartdoc === undefined) {
    logAndExit1(`Flag missing: use --no-dartdoc, --dartdoc, or --dartdoc=project-aliases`);
  }

  if (argv.dartdoc === false
    || argv.dartdoc === 'none') return [];
  if (argv.dartdoc === undefined
    || argv.dartdoc === true
    || argv.dartdoc === 'all') return [...config._dartdocProj];

  const result = [];
  argv.dartdoc.split(/\s*,\s*/).forEach(alias => {
    if (config._dartdocProj.indexOf(alias) === -1) {
      const msg = `Unrecognized dartdoc project alias: ${alias}.\n`
        + `Choose one of: ${config._dartdocProj.join(', ')}.`;
      logAndExit1(msg);
    }
    result.push(alias);
  });
  return result;
}

// Require a gulp task submodule
function _require(m) { require(`./gulp/${m}`)(gulp, plugins, config); }

//-----------------------------------------------------------------------------
// Tasks
//

const siteFolderContent = path.join(siteFolder, '*');
const _quickCleanTargets = [siteFolderContent, path.join(fragsPath, '**')];
const _cleanTargets = [
  siteFolderContent,
  LOCAL_TMP,
  path.join(source, '.asset-cache'),
];

function delFv(delTargets) { // verbose, forced delete
  myLog(`  Deleting: ${delTargets}.`);
  return del(delTargets, { force: true });
}

function clean() { return delFv(_cleanTargets); }
function _clean(done) {
  return !argv.clean ? done() :
    delFv(_quickCleanTargets.filter(p => argv.clean === true || p.includes(argv.clean)));
}

gulp.task('clean', clean);
gulp.task('_clean', _clean);
gulp.task('git-clean-src', () => execp(`git clean -xdf src`));

gulp.task('_clean-only-once', (done) =>
  _clean(() => {
    argv.clean = false; // Avoid a subcommand cleaning things out again
    done();
  }));

_require('example')
_require('pkg-vers')
_require('example-frag')
_require('example-add-apps')

gulp.task('_build-prep', gulp.series(
  '_clean-only-once',
  '_examples-get-repos',
  'create-example-fragments',
));

gulp.task('_jekyll-build', () => execp(`bundle exec jekyll build`));

// Task: build
// Options:
//   --fast  skips generation of dartdocs if they already exist

gulp.task('build', gulp.series(
  '_build-prep',
  '_examples-cp-to-site-folder',
  '_jekyll-build',
));

function _copyApiList(done) {
  execSyncAndLog('cp src/api/api-list.json src/_data/api-list.json');
  done();
}

gulp.task('default', taskListing.withFilters((taskName) => {
  var isSubTask = taskName.substr(0, 1) == "_";
  return isSubTask;
}, function (taskName) {
  var shouldRemove = taskName === 'default';
  return shouldRemove;
}));

gulp.task('git-status-exit-on-change', (done) => {
  let output = execSyncAndLog('git status --short');
  if (argv.filter) {
    output = output.split('\n').filter(s => s.match(argv.filter)).join('\n');
  }
  done();
  if (output) process.exit(1);
});

gulp.task('__test', () => {
  // Use to write experimental tasks.
});

gulp.task('compress-images', () => {
  const baseDir = argv.path
    ? path.resolve(argv.path)
    : path.resolve('.'); // project root
  if (!fs.existsSync(baseDir)) throw `ERROR: compress-images: path DNE "${baseDir}".`;
  myLog(`Compressing image files under: ${baseDir}`);
  return gulp.src([
    `${baseDir}/**/*.gif`,
    `${baseDir}/**/*.jpg`,
    `${baseDir}/**/*.jpeg`,
    `${baseDir}/**/*.png`,
    `!${baseDir}/**/.*/**`,
    `!${baseDir}/**/build/**`,
    `!${baseDir}/**/node_modules/**`,
  ], { base: baseDir })
    .pipe(imagemin([
      // imagemin.gifsicle({interlaced: true}),
      // imagemin.jpegtran({progressive: true}),
      imagemin.optipng({ optimizationLevel: 4 })]))
    .pipe(gulp.dest(baseDir))
});

_require('e2e')
_require('notes')
_require('test')
_require('update-ng-vers')

// Not currently used:
_require('get-stagehand-proj')
_require('example-template')

//=============================================================================
// Helper functions
//

function buildWebCompilerOptions() {
  const options = [
    // We don't have a way on Travis to conveniently clear severe errors from
    // previous runs, so omit the following option for now:
    // '--fail-on-severe',
    // '--delete-conflicting-outputs',
    '--output=web:build',
  ];
  if (argv.webCompiler === 'dartdevc' || !argv.webCompiler) options.push(`--no-release`);
  // if (argv.webCompiler === 'dart2js') options.push(...);
  return options.join(' ');
}

function generateBuildYaml(projectPath) {
  const buildYamlPath = path.join(projectPath, 'build.yaml');
  const pubspec = plugins.yamljs.load(path.join(projectPath, 'pubspec.yaml'));
  const buildYaml = _buildYaml(pubspec.name);
  plugins.myLog(`Generating ${buildYamlPath}:\n${buildYaml}`);
  plugins.fs.writeFileSync(buildYamlPath, buildYaml);
}

function _buildYaml(pkgName) {
  const buildYaml = `targets:
  ${pkgName}:
    builders:
      angular:
        options:
          use_new_template_parser: true
      build_web_compilers|entrypoint:
        options:
          compiler: ${argv.webCompiler || 'dartdevc'}
          ${argv.webCompiler === 'dart2js' ? 'dart2js_args: [--checked]' : ''}
`;
  return buildYaml;
}

function gitCheckDiff() {
  return execSyncAndLog('git status --short') && process.exit(1);
}

function getPathToApiDir(pkgName) {
  // const pkgsWithApiDocs = plugins.fs.readdirSync(config.tmpPubPkgsPath);
  const pubspecLockPath = path.join(config.srcData, 'pubspec.lock');

  if (!plugins.fs.existsSync(pubspecLockPath)) {
    const msg = `File not found: ${pubspecLockPath}. Run 'pub get' or 'pub upgrade' under ${config.srcData}`;
    if (config.dartdocProj.includes(p)) plugins.logAndExit1(`ERROR: ${msg}. Aborting.`);
    plugins.myLog(`WARNING: ${msg}`);
    return;
  }

  const pubspecLock = plugins.yamljs.load(pubspecLockPath);
  // const dirName = pkgsWithApiDocs.find(d => d.match(new RegExp(`^${pkgName}($|-)`)));
  // if(!dirName) { ... }

  const dirName = `${pkgName}-${pubspecLock.packages[pkgName].version}`;
  const pathToApi = path.join(config.tmpPubPkgsPath, dirName, config.relDartDocApiDir);
  return pathToApi;
}

// In addition to child_process.exec() options, pexec supports:
//
// - options.log = function(data) { ... } will be
//   called when there is data sent to stdout or stderr.
//
// - options.okOnExitRE <regex>, if provided, stdout is tested for
//   a line matching the given regex. On command exit,
//   the promise is rejected if no match was found.
//
// - options.errorOnExitRE <regex>, if provided, stdout and stderr are tested for
//   a line matching the given regex. On command exit,
//   the promise is rejected if a match was found.
function pexec(cmd, options) {
  // Inspired in part by https://stackoverflow.com/a/30883005/3046255
  myLog(`EXEC start: ${cmd} ${options ? JSON.stringify(options) : ''}`);

  let errorOnExit = false, okOnExit = !options || !options.okOnExitRE;

  function checkForOkOnExit(data) {
    if (options && options.okOnExitRE &&
      !okOnExit && data.match(options.okOnExitRE)) okOnExit = true;
  }
  function checkForErrorOnExit(data) {
    if (options && options.errorOnExitRE &&
      !errorOnExit && data.match(options.errorOnExitRE)) errorOnExit = true;
  }

  const proc = child_process.exec(cmd, options);
  if (options && options.log) {
    proc.stdout.on('data', data => {
      checkForOkOnExit(data);
      checkForErrorOnExit(data);
      options.log(data);
    });
    proc.stderr.on('data', data => {
      checkForErrorOnExit(data);
      options.log(data);
    });
  }

  const promise = new Promise((resolve, reject) => {
    function _onExit(exitCode) {
      let msg = errorOnExit ? `match for ${options.errorOnExitRE} found in stdout or stderr of`
        : !okOnExit ? `no match for ${options.okOnExitRE} found in stdout of`
          : exitCode ? `nonzero exit code ${exitCode} for`
            : 'successfully exited from';
      msg += ` ${cmd}`;
      if (options && options.cwd) msg += ` # ${options.cwd}`;
      myLog(`EXEC DONE: ${msg}`);
      msg.startsWith('success') ? resolve(0) : reject(msg);
    }
    proc.addListener('error', reject);
    proc.addListener('exit', _onExit);
  });
  return promise;
}

// Execute given command, and log and return command output.
// After printing stdout and stderr, this throws if there is an execution error.
function execSyncAndLog(cmd, optional_options) {
  const cwd = optional_options && optional_options.cwd ? ` # cwd: ${optional_options.cwd}` : '';
  myLog(`> ${cmd}${cwd}`);
  let output;
  try {
    const output = child_process.execSync(cmd, optional_options) + '';
    myLog(output);
    return output;
  } catch (e) {
    output = `ExecSync error in ${cmd}\n${e.stdout}\n${e.stderr}\n`;
    myLog(output);
    throw e;
  }
}

function execp(cmdAndArgs, options) {
  const cmd_and_args_arr = cmdAndArgs.split(' ');
  const pp = spawnExt(cmd_and_args_arr[0], cmd_and_args_arr.splice(1), options);
  return pp.promise;
}

// This version is used under angular.io for Windows folks ...
// returns both a promise and the spawned process so that it can be killed if needed.
function spawnExt(command, _args, options) {
  const args = _args || [];
  const deferred = Q.defer();
  let descr = command + " " + args.join(' ');
  if (options) descr += ' ' + JSON.stringify(options);
  let proc, okOnExit = !options || !options.okOnExitRE;
  myLog('EXEC start: ' + descr);
  try {
    proc = xSpawn.spawn(command, args, options);
  } catch (e) {
    myLog(e);
    deferred.reject(e);
    return { proc: null, promise: deferred.promise };
  }
  proc.stdout.on('data', data => {
    const out = data.toString();
    if (options && options.okOnExitRE && !okOnExit) {
      okOnExit = out.match(options.okOnExitRE);
    }
    myLog(out);
  });
  proc.stderr.on('data', data => myLog(data.toString()));
  proc.on('close', function (returnCode) {
    const exitOk = returnCode === 0 && okOnExit;
    const msg = exitOk ? 'successfully'
      : okOnExit ? `command return code is nonzero value ${returnCode}`
        : `okOnExit regex test ${options.okOnExitRE} failed over command output`;
    myLog(`EXEC DONE: ${msg} - ${descr}`);
    // Many tasks (e.g., tsc) complete but are actually errors;
    // Confirm return code is zero.
    exitOk ? deferred.resolve(0) : deferred.reject(returnCode);
  });
  proc.on('error', function (data) {
    myLog('EXEC DONE: ERROR: ' + descr);
    myLog(data.toString());
    deferred.reject(data);
  });
  return { proc: proc, promise: deferred.promise };
}

// Copies fileNames into destPaths, setting the mode of the
// files at the destination as optional_destFileMode if given.
// returns a promise
function copyFiles(fileNames, destPaths, optional_destFileMode) {
  var copy = Q.denodeify(fsExtra.copy);
  var chmod = Q.denodeify(fsExtra.chmod);
  var copyPromises = [];
  destPaths.forEach(function (destPath) {
    fileNames.forEach(function (fileName) {
      var baseName = path.basename(fileName);
      var destName = path.join(destPath, baseName);
      var p = copy(fileName, destName, { clobber: true });
      if (optional_destFileMode !== undefined) {
        p = p.then(function () {
          return chmod(destName, optional_destFileMode);
        });
      }
      copyPromises.push(p);
    });
  });
  return Q.all(copyPromises);
}

function logAndExit1(msg, optional_cb) {
  console.log(msg);
  if (optional_cb) {
    optional_cb(new Error(`logAndExit:\n${msg}`));
  }
  process.exit(1);
}

// Used to ensure that values/properties that are looked up from external
// sources are actually defined (when expecting a truthy value).
// Idiom: const foo = lookup('bar') || _throw()
function _throw(opt) { throw 'Unexpected value' + opt ? `:${opt}` : ''; }

function stringify(o, indentation_level) {
  return process.env.JEKYLL_ENV === 'production'
    ? JSON.stringify(o)
    : JSON.stringify(o, null, indentation_level === undefined ? 2 : indentation_level);
}

'use strict';

if (!process.env.NGIO_ENV_DEFS) {
  const msg = 'Some necessary environment variables are undefined.\n' +
    'Did you forget to: source ./scripts/env-set.sh?';
  console.log(msg);
  throw msg;
}

const gulp = require('gulp');
const gutil = require('gulp-util');

const argv = require('yargs').argv;
const assert = require('assert-plus');
const cheerio = require('gulp-cheerio');
const child_process = require('child_process');
const cpExec = require('child_process').exec;
const del = require('del');
const fsExtra = require('fs-extra');
const fs = fsExtra;
const globby = require("globby");
const path = require('canonical-path');
const Q = require("q");
const spawn = require('child_process').spawn;
const taskListing = require('gulp-task-listing');
// cross platform version of spawn that also works on windows.
const xSpawn = require('cross-spawn');
const yamljs = require('yamljs');

function xExec(cmd_and_args, options) {
  const cmd_and_args_arr = cmd_and_args.split(' ');
  const pp = spawnExt(cmd_and_args_arr[0], cmd_and_args_arr.splice(1), options);
  return pp;
}

const exec = xExec; // cpExec;
const npmbin = path.resolve('node_modules/.bin');
const npmbinMax = `node --max-old-space-size=4096 ${npmbin}`;

const THIS_PROJECT_PATH = path.resolve('.');
const _configYml = yamljs.load('_config.yml');

const siteFolder = _configYml.destination || _throw();

// angular.io constants
const EXAMPLES_ROOT = 'examples';
const EXAMPLES_NG_DOC_PATH = './examples/ng/doc'; // used to be named EXAMPLES_PATH
const TOOLS_PATH = './tools';
const TMP_PATH = process.env.TMP; // shared temp folder (for larger downloads, etc)
const LOCAL_TMP = 'tmp'; // temp folder local to this project
if (!fs.existsSync(LOCAL_TMP)) fs.mkdirpSync(LOCAL_TMP);

const angulario = path.resolve('../angular.io');

const isSilent = !!argv.silent;
if (isSilent) gutil.log = gutil.noop;
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
  exAppPubGetOrUpgradeCmd: 'upgrade', // or 'get', see https://github.com/dart-lang/site-webdev/issues/1195
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
    acx: process.env.ACX_REPO,
    forms: path.join(process.env.NG_REPO, 'angular_forms'),
    ng: path.join(process.env.NG_REPO, 'angular'),
    router: path.join(process.env.NG_REPO, 'angular_router'),
    test: path.join(process.env.NG_REPO, 'angular_test'),
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
  child_process: child_process,
  copyFiles: copyFiles,
  del: del,
  delFv: delFv,
  execSyncAndLog: execSyncAndLog,
  execp: execp,
  filter: require('gulp-filter'),
  fs: fs,
  genDartdocForProjs: genDartdocForProjs,
  gitCheckDiff: gitCheckDiff,
  globby: globby,
  gutil: gutil,
  logAndExit1: logAndExit1,
  path: path,
  pkgAliasToPkgName: pkgAliasToPkgName,
  q: Q,
  rename: require('gulp-rename'),
  replace: require('gulp-replace'),
  runSequence: require('run-sequence'),
  spawnExt: spawnExt,
  stringify: stringify,
  yamljs: yamljs,
};

config.dartdocProj = genDartdocForProjs();
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

  if (argv.dartdoc === false) return [];
  if (argv.dartdoc === undefined || argv.dartdoc === true) return [...config._dartdocProj];

  const result = [];
  argv.dartdoc.split(/\s*,\s*/).forEach(alias => {
    if (alias === 'all') return [...config._dartdocProj];
    if (config._dartdocProj.indexOf(alias) === -1) {
      const msg = `Unrecognized dartdoc project alias: ${alias}.\n`
        + `Choose one of: ${config._dartdocProj.join(', ')}.`;
      logAndExit1(msg);
    }
    result.push(alias);
  });
  return result;
}

const extraTasks = `
  api api-list dartdoc e2e example example-add-apps example-frag example-template
  get-stagehand-proj ngio-get ngio-put pkg-vers test update-ng-vers`;
extraTasks.split(/\s+/).forEach(task => task && require(`./gulp/${task}`)(gulp, plugins, config))

//-----------------------------------------------------------------------------
// Tasks
//

// Task: build
// Options:
//   --fast  skips generation of dartdocs if they already exist
//
// Ideally, we'd want to ensure that get-stagehand-proj completes before the other
// tasks but it is too much work to do that in gulp 3.x. Generally it shouldn't be
// a problem. We can always fix the dependencies once gulp 4.x is out.
gulp.task('build', ['get-stagehand-proj', 'create-example-fragments', 'dartdoc',
  'build-api-list-json', 'finalize-api-docs', 'add-example-apps-to-site'], cb => {
    // Make API lists available for the sitemap generation:
    child_process.execSync(`cp src/api/api-list.json src/_data/api-list.json`);
    return execp(`jekyll build`);
  });

gulp.task('build-deploy', ['build'], () => {
  // Note: .firebaserc will be used.
  return execp(`firebase deploy`);
});

gulp.task('site-refresh', ['_clean', 'get-ngio-files']);

const _quickCleanTargets = [siteFolder, path.join(fragsPath, '**')];
const _cleanTargets = [
  siteFolder,
  LOCAL_TMP,
  path.join(source, _configYml.assets.cache || _throw()),
];
function delFv(delTargets) { // verbose, forced delete
  gutil.log(`  Deleting: ${delTargets}.`);
  return del(delTargets, { force: true });
}
gulp.task('clean', () => delFv(_cleanTargets));
gulp.task('_clean', done => !argv.clean ? done() :
  delFv(_quickCleanTargets.filter(p => argv.clean === true || p.includes(argv.clean))));
gulp.task('git-clean-src', () => execp(`git clean -xdf src`));

gulp.task('default', ['help']);

gulp.task('help', taskListing.withFilters((taskName) => {
  var isSubTask = taskName.substr(0, 1) == "_";
  return isSubTask;
}, function (taskName) {
  var shouldRemove = taskName === 'default';
  return shouldRemove;
}));

gulp.task('git-check-diff', () => {
  execSyncAndLog('git status --short') && process.exit(1);
});

gulp.task('__test', () => {
  // Use to write experimental tasks.
});

//=============================================================================
// Helper functions
//

function gitCheckDiff() {
  return execSyncAndLog('git status --short') && process.exit(1);
}

// Execute given command, and log and return command output
function execSyncAndLog(cmd, optional_options) {
  const cwd = optional_options && optional_options.cwd ? ` # cwd: ${optional_options.cwd}` : '';
  gutil.log(`> ${cmd}${cwd}`);
  const output = child_process.execSync(cmd, optional_options) + '';
  gutil.log(output);
  return output;
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
  let proc;
  gutil.log('async exec: ' + descr);
  try {
    proc = xSpawn.spawn(command, args, options);
  } catch (e) {
    gutil.log(e);
    deferred.reject(e);
    return { proc: null, promise: deferred.promise };
  }
  proc.stdout.on('data', data => gutil.log(data.toString()));
  proc.stderr.on('data', data => gutil.log(data.toString()));
  proc.on('close', function (returnCode) {
    gutil.log('completed: ' + descr);
    // Many tasks (e.g., tsc) complete but are actually errors;
    // Confirm return code is zero.
    returnCode === 0 ? deferred.resolve(0) : deferred.reject(returnCode);
  });
  proc.on('error', function (data) {
    gutil.log('completed with error:' + descr);
    gutil.log(data.toString());
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

function logAndExit1() {
  console.log.apply(null, arguments);
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

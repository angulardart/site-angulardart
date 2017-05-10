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
const cheerio = require('gulp-cheerio');
const child_process = require('child_process');
const cpExec = require('child_process').exec;
const del = require('del');
const fsExtra = require('fs-extra');
const fs = fsExtra;
const globby = require("globby");
// const os = require('os');
const path = require('canonical-path');
const Q = require("q");
const replace = require('gulp-replace');
const spawn = require('child_process').spawn;
const taskListing = require('gulp-task-listing');
// cross platform version of spawn that also works on windows.
const xSpawn = require('cross-spawn');

function xExec(cmd_and_args, options) {
  const cmd_and_args_arr = cmd_and_args.split(' ');
  const pp = spawnExt(cmd_and_args_arr[0], cmd_and_args_arr.splice(1), options);
  return pp;
}

const exec = xExec; // cpExec;
const npmbin = path.resolve('node_modules/.bin');
const npmbinMax = `node --max-old-space-size=4096 ${npmbin}`;

const THIS_PROJECT_PATH = path.resolve('.');
// angular.io constants
// TODO: get path from the env
const PUBLIC_PATH = './public';
const DOCS_PATH = path.join(PUBLIC_PATH, 'docs');
const EXAMPLES_PATH = './examples/ng/doc';
const TOOLS_PATH = './tools';
const TMP_PATH = process.env.TMP;

const angulario = path.resolve('../angular.io');

const isSilent = !!argv.silent;
if (isSilent) gutil.log = gutil.noop;
const _dgeniLogLevel = argv.dgeniLog || (isSilent ? 'error' : 'warn');

const ngDocSrc = path.join('src', 'angular');
const fragsPath = path.join(ngDocSrc, '_fragments');
const qsProjName = 'angular_quickstart';
const config = {
  _dgeniLogLevel: _dgeniLogLevel,
  angulario: angulario,
  dartdocProj: ['acx', 'ng'],
  repoPath: {
    acx: process.env.ACX_REPO,
    ng: process.env.NG2_REPO,
  },
  DOCS_PATH: DOCS_PATH,
  EXAMPLES_PATH: EXAMPLES_PATH,
  ngDocSrc: ngDocSrc,
  qsProjName: qsProjName,
  relDartDocApiDir: path.join('doc', 'api'),
  THIS_PROJECT_PATH: THIS_PROJECT_PATH,
  TOOLS_PATH: TOOLS_PATH,
  frags: {
    apiDirName: '_api',
    dirName: path.basename(fragsPath),
    path: fragsPath,
  },
  webSimpleProjPath: path.join(TMP_PATH, qsProjName),
};

const warnedAboutSkipping = { acx: false, ng: false };
function genDartdocForProjs() {
  const projs = [];
  config.dartdocProj.forEach(p => {
    if (!_dartdocForRepo(p)) {
      return true;
    } else if (fs.existsSync(path2ApiDocFor(p)) && !argv.clean && argv.fast) {
      if (!warnedAboutSkipping[p])
        plugins.gutil.log(`Skipping ${p} dartdoc: --fast flag enabled and API docs exists ${path2ApiDocFor(p)}`);
      warnedAboutSkipping[p] = true;
    } else {
      projs.push(p);
    }
  });
  return projs;
}

function path2ApiDocFor(r) {
  return path.resolve(config.repoPath[r], config.relDartDocApiDir);
}

function _dartdocForRepo(repo) {
  if (argv.dartdoc === undefined || argv.dartdoc == 'all') return true;
  const re = new RegExp('\\b' + repo + '\\b');
  return (argv.dartdoc + '').match(re);
}

const plugins = {
  argv: argv,
  child_process: child_process,
  copyFiles: copyFiles,
  del: del,
  execp: execp,
  fs: fs,
  genDartdocForProjs: genDartdocForProjs,
  globby: globby,
  gutil: gutil,
  path2ApiDocFor: path2ApiDocFor,
  path: path,
  q: Q,
  replace: replace,
  spawnExt: spawnExt
};

const extraTasks = `
  api api-list cheatsheet dartdoc examples example-frag example-template
  get-stagehand-proj ngio-get ngio-put sass test update-ng-vers`;
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
  'build-api-list-json', 'build-cheatsheet', 'finalize-api-docs', 'sass'], cb => {
    // There is a rule in public/docs/_examples/.gitignore that prevents a2docs.css
    // from being excluded. Let's stay synced with the TS counterpart of that .gitignore
    // and just delete the file:
    child_process.execSync(`rm -f public/docs/_examples/_boilerplate/a2docs.css`);
    return execp(`jekyll build`);
  });

gulp.task('build-deploy', ['build'], () => {
  // Note: .firebaserc will be used.
  return execp(`firebase deploy`);
});

gulp.task('site-refresh', ['_clean', 'get-ngio-files']);

const _cleanTargets = ['publish'];
const _delTmp = () => del(_cleanTargets, { force: true });
gulp.task('clean', cb => _delTmp());
gulp.task('_clean', cb => argv.clean ? _delTmp() : cb());
gulp.task('clean-src', cb => execp(`git clean -xdf src`));

gulp.task('default', ['help']);

gulp.task('help', taskListing.withFilters((taskName) => {
  var isSubTask = taskName.substr(0, 1) == "_";
  return isSubTask;
}, function (taskName) {
  var shouldRemove = taskName === 'default';
  return shouldRemove;
}));


//=============================================================================
// Helper functions
//

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

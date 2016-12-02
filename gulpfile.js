'use strict';

const gulp = require('gulp');
const gutil = require('gulp-util');

const argv = require('yargs').argv;
const cheerio = require('gulp-cheerio');
const child_process = require('child_process');
const cpExec = require('child_process').exec;
const del = require('del');
const fsExtra = require('fs-extra');
const fs = fsExtra;
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

const angulario = path.resolve('../angular.io');
gutil.log(`Using angular.io repo at ${angulario}`)

const config = {
  angularRepo: '../angular2',
  relDartDocApiDir: path.join('doc', 'api'),
};
const plugins = {argv:argv, execp:execp, fs:fs, gutil:gutil, path:path, q:Q} // TODO: use plugins pkg

const extraTasks = 'api dartdoc sass';
extraTasks.split(' ').forEach(task => require(`./gulp/${task}`)(gulp, plugins, config))

//-----------------------------------------------------------------------------
// Tasks
//

gulp.task('build', ['get-api-docs', 'sass'], cb => {
  gutil.log('\n*******************************************************************************')
  gutil.log('It is assumed that get-ngio-files was run earlier. If not, the build will fail.');
  gutil.log('*******************************************************************************\n')
  return execp(`jekyll build`);
});

gulp.task('build-deploy', ['build'], () => {
  // Note: .firebaserc will be used.
  return execp(`firebase deploy`);
});

gulp.task('site-refresh', ['_clean', 'get-ngio-files']);

gulp.task('get-ngio-files', ['_clean', '_get-pages', '_get-resources', '_get-frag']);

const _cleanTargets = ['publish'];
const _delTmp = () => del(_cleanTargets, { force: true });
gulp.task('clean', cb => _delTmp());
gulp.task('_clean', cb => argv.clean ? _delTmp() : cb());
gulp.task('clean-src', cb => execp(`git clean -xdf src`));

gulp.task('_get-frag', cb => {
  const baseDir = path.join(angulario, 'public/docs');
  return gulp.src([
    `${baseDir}/_fragments/**`,
    `!${baseDir}/_fragments/**/ts/**`,
    `!${baseDir}/_fragments/_api/**`,
  ], { base: baseDir })
    .pipe(gulp.dest('src/angular'));
});

gulp.task('_get-pages', ['_get-ts-jade', '_get-tutorial', '_get-api-ref-page',
  '_get-guide', '_get-extra-dart', '_get-includes'], () => {
  return Q.all(
    // Move cheatsheet.json to the same folder as cheatsheet.jade
    execp(`mv src/angular/guide/cheatsheet.json src/angular/`),
    // Remove <br clear> from learning-angular.jade
    cpExec(`perl -pi -e 's/<br class="l-clear-left">//' src/angular/_jade/ts/_cache/guide/learning-angular.jade`)
  );
});

gulp.task('_get-ts-jade', cb => {
  const baseDir = path.join(angulario, 'public/docs');
  return gulp.src([
    `${baseDir}/ts/_cache/**/*.jade`,
    `!${baseDir}/ts/**/api/**`,
  ], { base: baseDir })
    // We don't need to include the ts _util-fns.jade file; comment it out.
    .pipe(replace(/include (\.\.\/)*_util-fns(\.jade)?/g, '//- $&'))
    // General patch
    .pipe(replace(/target="_blank"/g, '$& rel="noopener"'))
    // Patch toh-5; don't include TS-specific _see-addr-bar.jade
    .pipe(replace(/include (\.\.\/)*_includes\/_see-addr-bar(\.jade)?/g, '//- $&'))
    // Patch guide/index - set the advancedLandingPage  because it is not worth trying to read it from the harp _data file
    .pipe(replace(/(var guideData =)[^;]*/, '$1 {}'))
    .pipe(replace(/(var advancedLandingPage =)[^;]*/, "$1 'attribute-directives'"))
    // Patch structural-directives
    .pipe(replace('## The *&lt;template>* tag', '## The *template* tag'))
    // Patch tempalte-syntax: w/o it the page doesn't render because of JS error: $("#page-footer").offset() is undefined
    .pipe(replace('## * and &lt;template&gt;', '## `*` and *template*'))
    // Patch glossary
    .pipe(replace("var docsLatest='/' + current.path.slice(0,3).join('/');", "var docsLatest='/angular';"))
    .pipe(gulp.dest('src/angular/_jade'));
});

gulp.task('_get-extra-dart', () => {
  const baseDir = path.join(angulario, 'public/docs/dart/latest');
  return gulp.src([
    `${baseDir}/api/api-list.json`,
    `${baseDir}/_util-fns.jade`,
    `${baseDir}/guide/cheatsheet.json`, // will be moved up one level in _get-pages
  ], { base: baseDir })
    // Patch _util-fns.jade
    .pipe(replace(/include +(\.\.\/)+_includes\//, 'include /_jade/'))
    .pipe(gulp.dest('src/angular'));
});

gulp.task('_get-includes', () => {
  const baseDir = path.join(angulario, 'public/_includes');
  return gulp.src([
    `${baseDir}/_util-fns.jade`,
  ], { base: baseDir })
    // Patch _util-fns.jade
    .pipe(replace(/^/, '- var jade2ng = true;\n'))
    .pipe(replace(/(\-  )( var frag = partial\(fullFileName\);)/, '$1 return \'!= partial("\' + fullFileName + \'")\';\n$1$2'))
    .pipe(gulp.dest('src/angular/_jade'));
});

gulp.task('_get-api-ref-page', () => {
  const data = { "index": { "title" : "API Reference v<ngio-cheatsheet src='/angular/cheatsheet.json' version-only>2</ngio-cheatsheet>" } };
  return _getNgIoJadeForDir('api', data);
});

gulp.task('_get-guide', () => {
  const data = {
    "quickstart": {
        "title": "Quickstart",
        "description": "Get up and running with Angular",
      },
    "cheatsheet": {
      "title": "Cheat Sheet v<ngio-cheatsheet src='/angular/cheatsheet.json' version-only>2</ngio-cheatsheet>",
    },
    "glossary": {
      "title": "Glossary",
      "intro": "Brief definitions of the most important words in the Angular vocabulary",
    },
  };
  _getNgIoJadeForDir('', data);
  _getNgIoJadeForDir('guide', null, ['cheatsheet', 'glossary']);
  return true;
});

gulp.task('_get-tutorial', () => _getNgIoJadeForDir('tutorial'));

function _getNgIoJadeForDir(dir, _data, _skiplist) {
  const skipList = _skiplist || [];
  const srcDir = path.join(angulario, `public/docs/dart/latest/${dir}`);
  const destDir = path.resolve(`./src/angular/${dir}`);
  const data = _data || require(path.join(srcDir, '_data.json'));

  // Create array to establish prev/next pages
  const prevNextArray = [];
  Object.keys(data).forEach(fileNameNoExt => {
    const fileName = `${fileNameNoExt}.jade`;
    const filePath = path.join(srcDir, fileName);
    const entry = data[fileNameNoExt];
    if (entry.hide || !fs.existsSync(filePath) || skipList.includes(fileNameNoExt)) {
      return true;
    }
    prevNextArray.push(fileNameNoExt);
  });

  Object.keys(data).forEach(fileNameNoExt => {
    const fileName = `${fileNameNoExt}.jade`;
    const filePath = path.join(srcDir, fileName);
    const entry = data[fileNameNoExt];
    if (entry.hide || !fs.existsSync(filePath) || skipList.includes(fileNameNoExt)) {
      gutil.log(`  >> skipping ${fileName}`);
      return true;
    }
    let pageConfig = `WARNING: THIS FILE IS AUTOGENERATED FROM ANGULAR.IO; DO NOT EDIT
layout: angular
title: "${entry.title}"
description: "${(entry.description || entry.intro || '').replace(/"/g, '\\"')}"
angular: true
`;
    const sideNavGroup = entry.basics ? 'basic' : dir === 'guide' ? 'advanced' : '';
    if (sideNavGroup) pageConfig = pageConfig + `sideNavGroup: ${sideNavGroup}\n`;
    if (dir == 'api' || fileNameNoExt.match(/quickstart|cheatsheet|learning-angular/)) pageConfig = pageConfig + `toc: false\n`;

    // Handle prev/next links
    // Sample:
    //   nextpage:
    //     title: "1. The Hero Editor"
    //     url: /angular/tutorial/toh-pt1
    const pageIdx = prevNextArray.indexOf(fileNameNoExt);
    if (dir && pageIdx > -1 /*&& entry.nextable*/) {
      if (pageIdx > 0) {
        const _linkUri = prevNextArray[pageIdx-1];
        const _otherEntry = data[_linkUri];
        pageConfig = pageConfig + `prevpage:\n`
          + `  title: "${_otherEntry.title}"\n`
          + `  url: /angular/${dir}/${_linkUri}\n`;
      }
      if (pageIdx < prevNextArray.length - 1) {
        const _linkUri = prevNextArray[pageIdx+1];
        const _otherEntry = data[_linkUri];
        pageConfig = pageConfig + `nextpage:\n`
          + `  title: "${_otherEntry.title}"\n`
          + `  url: /angular/${dir}/${_linkUri}\n`;
      }
    }

    const jekyllYaml = `---\n${pageConfig}---\n`;
    const destFile = path.join(destDir, fileName);
    let jade = fs.readFileSync(filePath, {encoding: 'utf-8'});
    jade = jade
      .replace(/^/, `//- FilePath: ${destFile.replace(/.*\/(src\/)/, '$1')}\n`)
      // General patches
      .replace(/extends +(\.\.\/)*ts\//, 'extends /_jade/ts/')
      // .replace(/include (\.\.\/)*((_util-fns|_quickstart_repo)(\.jade)?)/g, 'include $2')
      .replace(/include (\.\.\/)*_includes\/(_ts-temp(\.jade)?)/g, 'include /_jade/$2')
      .replace('src="api-list.json"', 'src="/angular/api/api-list.json"');
    if (fileNameNoExt != 'index') {
      const exampleName = fileNameNoExt.replace(/pt/, '');
      jade = jade.replace(/block includes/, `$&\n  - var _example = '${exampleName}';`);
    }
    fs.writeFileSync(destFile, jekyllYaml + jade);
    // fs.appendFileSync(filePath, jade);
    gutil.log(`  ${fileNameNoExt} -> ${destFile}`);
  });
  return true;
}

gulp.task('_get-resources', ['_get-rsrc-images1', '_get-rsrc-images2', '_get-rsrc-other']);

gulp.task('_get-rsrc-images1', cb => {
  const baseDir = path.join(angulario, 'public');
  return gulp.src([`${baseDir}/resources/images/**/*`], { base: baseDir }).pipe(gulp.dest('src'));
});

gulp.task('_get-rsrc-images2', cb => {
  const baseDir = path.join(angulario, 'public/docs/dart/latest');
  return gulp.src([`${baseDir}/guide/images/**`], { base: baseDir }).pipe(gulp.dest('src/angular'));
});

gulp.task('_get-rsrc-other', cb => {
  const baseDir = path.join(angulario, 'public');
  const ngIoApp = "angular.module('angularIOApp', ['ngMaterial', 'firebase'])";
  const dropFirebase = ngIoApp.replace(", 'firebase'", '')
  return gulp.src([
    `${baseDir}/resources/js/**/*`,
    `${baseDir}/resources/css/_options.scss`,
    `${baseDir}/resources/css/layout/_{grids,layout}.scss`,
    `${baseDir}/resources/css/base/_{colors,mixins,reset}.scss`,
    `${baseDir}/resources/css/module/_{alert,api,banner,buttons,callout,code,code-box,code-shell,filetree,form,symbol,table}.scss`,
    `!${baseDir}/resources/js/vendor/{jquery,lang-*,prettify}.js`,
    `!${baseDir}/resources/js/controllers/resources-controller.js`,
  ], { base: baseDir })
    // Patch resources/js/site.js
    .pipe(replace(ngIoApp, dropFirebase))
    // Patch resources/js/directives/api-list.js
    .pipe(replace(
      `<a ng-href="{{ item.path }}">`,
      `<a ng-href="{{ \\'/angular/api/\\' + item.path }}" target="_blank" rel="noopener">`
    ))
    // Patch live-example.js
    .pipe(replace(/target: '_blank/g, '$&" rel="noopener'))
    // Patch resources/js/util.js
    .pipe(replace("loc.includes('/docs/' + lang + '/')", "loc.includes('/angular/')"))
    .pipe(gulp.dest('src'));
});

gulp.task('_get-x', cb => {
  const baseDir = path.join(angulario, WWW);
  return gulp.src([
    `${baseDir}/*.html`,
    `!${baseDir}/google*.html`,
    `${baseDir}/docs/*/latest/**/*`,
    `!${baseDir}/docs/*/latest/api/api-list.json`,
    `!${baseDir}/docs/*/latest/api/api-list-audit.json`,
    `!${baseDir}/docs/*/latest/api/*.html`,
    `!${baseDir}/docs/*/latest/guide/cheatsheet.json`,
    `!${baseDir}/docs/dart/latest/api/static-assets`,
    `!${baseDir}/docs/dart/latest/api/static-assets/**/*`,
  ], { base: baseDir })
    // Adjust opening and closing tags for elements getting an `ngio-` prefix.
    .pipe(cheerio(ng1ToNg2HtmlAdj))
    // .pipe(replace(/<(code-(example|tabs|pane))/g, '<ngio-$1'))
    // .pipe(replace(/<\/(code-(example|tabs|pane))/g, '</ngio-$1'))
    .pipe(gulp.dest('src/pages'));
});

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
  const descr = command + " " + args.join(' ');
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

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
const sass = require('gulp-sass');
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

// if (!process.env.NGIO1_REPO) {
//   const msg = `NGIO1_REPO is not set, aborting. Maybe you need to source './scripts/env-set.sh'?`;
//   throw msg;
// }

const WWW = 'www-pages';
const angulario = path.resolve('../angular.io');
gutil.log(`Using angular.io repo at ${angulario}`)

const config = { }
const plugins = {fs:fs, path:path, q:Q} // TODO: use plugins pkg

require('./gulp/api')(gulp, plugins, config)

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

gulp.task('sass', cb => _sass('src/styles'));
gulp.task('clean-src', cb => execp(`git clean -xdf src`));

gulp.task('site-refresh', ['_clean', 'get-ngio-files']);

gulp.task('get-ngio-files', ['_clean', '_get-pages', '_get-resources', '_get-frag']);

const _cleanTargets = ['publish'];

const _delTmp = () => del(_cleanTargets, { force: true });

gulp.task('clean', cb => _delTmp());
gulp.task('_clean', cb => argv.clean ? _delTmp() : cb());

gulp.task('compile', ['_clean'], cb => {
  gutil.log(`WARNING: you must manually 'build-compile' or 'harp-compile' using '--page' from the ng1.io site`);
  return true;
  // const _jade2ngCmd = `./scripts/jade2ng.sh`;
  // return execp(_jade2ngCmd);
});

gulp.task('_get-frag', cb => {
  const baseDir = path.join(angulario, 'public/docs');
  return gulp.src([
    `${baseDir}/_fragments/**`,
    `!${baseDir}/_fragments/**/ts/**`,
    `!${baseDir}/_fragments/_api/**`,
  ], { base: baseDir })
    .pipe(gulp.dest('src/angular'));
});

// TODO(chalin): copy over _util-fns.jade files & apply patches
gulp.task('_get-pages', ['_get-ts-jade', '_get-tutorial', '_get-api', '_get-guide', '_get-extra']);

gulp.task('_get-ts-jade', cb => {
  const baseDir = path.join(angulario, 'public/docs');
  return gulp.src([
    `${baseDir}/ts/_cache/**/*.jade`,
    `${baseDir}/ts/latest/guide/index.jade`,
    `${baseDir}/ts/latest/_quickstart_repo.jade`,
    `!${baseDir}/ts/**/api/**`,
  ], { base: baseDir })
    .pipe(replace(/include (\.\.\/)*_util-fns(\.jade)?/g, '//- $&'))
    // Patch tempalte-syntax: w/o it the page doesn't render because of JS error: $("#page-footer").offset() is undefined
    .pipe(replace('## * and &lt;template&gt;', '## `*` and *template*'))
    // Patch glossary
    .pipe(replace("var docsLatest='/' + current.path.slice(0,3).join('/');", "var docsLatest='/angular';"))
    .pipe(gulp.dest('src/angular/_jade'));
});

gulp.task('_get-extra', cb => {
  const baseDir = path.join(angulario, 'public/docs/dart/latest');
  return gulp.src([
    `${baseDir}/_quickstart_repo.jade`,
    `${baseDir}/api/api-list.json`,
    `${baseDir}/guide/cheatsheet.json`,
  ], { base: baseDir })
    .pipe(gulp.dest('src/angular'));
});

gulp.task('_get-api', cb => {
  const data = { "index": { "title" : "API Reference", "description" : "API Reference" } };
  return _getNgIoJadeForDir('api', data);
});

gulp.task('_get-guide', cb => {
  const data = {
    "quickstart": {
        "title": "Quickstart",
        "description": "Get up and running with Angular",
      },
    "cheatsheet": {
      "title": "Angular Cheat Sheet",
      "intro": "A quick guide to Angular syntax. (Content is provisional and may change.)",
    },

    "glossary": {
      "title": "Glossary",
      "intro": "Brief definitions of the most important words in the Angular vocabulary",
    },
  };
  _getNgIoJadeForDir('', data);
  _getNgIoJadeForDir('guide');
  return true;
});

gulp.task('_get-tutorial', cb => _getNgIoJadeForDir('tutorial'));

function _getNgIoJadeForDir(dir, _data) {
  const srcDir = path.join(angulario, `public/docs/dart/latest/${dir}`);
  const destDir = path.resolve(`./src/angular/${dir}`);
  const data = _data || require(path.join(srcDir, '_data.json'));
  Object.keys(data).forEach(fileNameNoExt => {
    const fileName = `${fileNameNoExt}.jade`;
    const filePath = path.join(srcDir, fileName);
    const entry = data[fileNameNoExt];
    if (entry.hide || !fs.existsSync(filePath) || fileNameNoExt == 'cheatsheet') {
      gutil.log(`  >> skipping ${fileName}`);
      return true;
    }
    const jekyllYaml = `---
layout: angular
title: "${entry.title}"
description: "${(entry.description || entry.intro).replace(/"/g, '\\"')}"
angular: true
---
`;
    const destFile = path.join(destDir, fileName);
    let jade = fs.readFileSync(filePath, {encoding: 'utf-8'});
    jade = jade
      .replace(/^/, `//- FilePath: ${destFile.replace(/.*\/(src\/)/, '$1')}\n`)
      // General patches
      // .replace(/extends +(\.\.\/)*(cheatsheet|glossary)/, 'extends $2')
      .replace(/extends +(\.\.\/)*ts\//, 'extends /_jade/ts/')
      // .replace(/include (\.\.\/)*((_util-fns|_quickstart_repo)(\.jade)?)/g, 'include $2')
      .replace(/include (\.\.\/)*_includes\/(_ts-temp(\.jade)?)/g, 'include /_jade/$2')
      .replace('src="api-list.json"', 'src="api/api-list.json"');
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

gulp.task('_get-resources', ['_get-rsrc-images', '_get-rsrc-js']);

gulp.task('_get-rsrc-images', cb => {
  const baseDir = path.join(angulario, 'public');
  return gulp.src([`${baseDir}/resources/images/**/*`], { base: baseDir }).pipe(gulp.dest('src'));
});

gulp.task('_get-rsrc-js', cb => {
  const baseDir = path.join(angulario, 'public');
  const ngIoApp = "angular.module('angularIOApp', ['ngMaterial', 'firebase'])";
  const dropFirebase = ngIoApp.replace(", 'firebase'", '')
  return gulp.src([
    `${baseDir}/resources/js/**/*`,
    `!${baseDir}/resources/js/vendor/{jquery,lang-*,prettify}.js`,
    `!${baseDir}/resources/js/controllers/resources-controller.js`,
  ], { base: baseDir })
    // Patch resources/js/site.js
    .pipe(replace(ngIoApp, dropFirebase))
    // Patch resources/js/directives/api-list.js
    .pipe(replace(
      `<a ng-href="{{ item.path }}">`,
      `<a ng-href="{{ \\'/angular/api/\\' + item.path }}" target="_blank">`
    ))
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

function ng1ToNg2HtmlAdj($, file) {
  const relPath = file.relative;
  const uriPathPrefix = '/' + path.dirname(relPath);
  const baseName = path.basename(relPath, '.html');

  // TODO: also fix span's with ngio-ex attr
  $('ngio-ex').each((i, e) => $(e).replaceWith(`<code>${$(e).text()}</code>`));

  // // Temporary fix until we can figure out how to test if ng-content is empty:
  // $('live-example').each((i, e) => { if (!$(e).html()) $(e).text('live example'); });

  // The next two are for TS API page cleanup:
  // - <pre ng-class=""> strip out this ng1 feature; it will be re-implemented in ng2.
  // - ng-cloak isn't used in ng2
  $('pre[ng-class]').attr('ng-class', null);
  $('.ng-cloak').removeClass('ng-cloak');

  // Rewrite <a href="...">
  $('a').each((i, e) => {
    let href = $(e).attr('href')
    if (!href) return true;

    // Remove '\n' which sometimes appear in hrefs generated from markdown.
    href = href.replace(/\n/, '');
    // console.error(`  >> href: ${href}`);

    if (href.match(/^[a-z]+:/)) return true; // Do nothing to external links
    if (href.endsWith('plnkr.html')) return true; // Leave links to external plunkers as is.

    // Intra-site link, e.g.:
    //
    // - /docs/ts/latest/guide/template-syntax.html#ng-model
    // - guide/page.html#frag
    // - ../tutorial
    // 
    // <a routerLink="/docs/guides/page" fragment="frag">...</a>
    //
    // TODO: also generate a title?
    //    title="Add structure to the app with NgModule"

    let routerLink = '', fragment = '', matches;

    // https://github.com/angular/ng2-angular.io/issues/167
    // // TODO: consider matching against names read from the appropriate _data.json file.
    // // Hardcoding names of basics pages in regex matcher for now (glossary is handled below):
    // if (href.match(/\/guide\/(architecture|dependency-injection|displaying-data|forms|forms-deprecated|style-guide|template-syntax|user-input)/)) {
    //   href = href.replace(/\/guide\//, '/basics/');
    // }

    // Rewrite links to the glossary:
    // - .../guide/glossary -> .../glossary
    href = href.replace(/\/guide\/glossary.html/, '/glossary.html');
    // - In a guide page, reference the top-level glossary
    if (matches = href.match(/^(\.\/)?(glossary.html.*)$/)) href = `../${matches[2]}`;

    // Rewrite links to the cheatsheet:
    if (matches = href.match(/^(\.\/)?(cheatsheet.html.*)$/)) href = `../${matches[2]}`;

    matches = href.match(/([^#]*)(#!)?#([-\w]*$)/);
    if (matches) {
      href = matches[1];
      fragment = matches[3];
      // console.error(`    >> matched frag: href=${href} fragment=${fragment}`);
    }

    // https://github.com/angular/ng2-angular.io/issues/168 - fall back to using .html suffix
    // href = href.replace(/\.html$/, ''); // Remove trailing .html for docs pages
    // https://github.com/angular/angular-cli/issues/2168 - here is a workaround
    // href = href.replace(/\.html$/, '_html');

    if (href.startsWith('./')) href = href.substring(2);
    if (href === '') {
      href = `${uriPathPrefix}/${baseName}.html`;
    } else if (!href.startsWith('/')) {
      // TODO: consider removing this extra processing of the html path. It might not be needed under ng2ce.

      // Note that an original href starting with './xyz' also ends up here as 'xyz'.
      // 
      // Map all relative hrefs (like 'guide/page', or '../cookbook/abc')
      // to an absolute page ref. We can't just let such refs pass through
      // because they could appear in a page with route:
      //
      //   https://ng2.io/docs/ts/latest/quickstart
      //
      // in which case we would want the href to be '../guide/page'. But if the
      // route corresponds to a chapter or a docs language or version section like
      //
      //   https://ng2.io/docs/ts/latest/, or
      //   https://ng2.io/docs/ts/latest/guide/
      //
      // then we want the href stay as it is. To avoid trying to figure
      // out if the route is for a page or a chapter (which can be tricky since
      // routing and redirects are set elsewhere), we currently just rewrite
      // the href so that it is absolute. So our sample href becomes:
      //
      //   ${uriPathPrefix}/${href}
      //
      // e.g.
      //
      //   /docs/ts/latest/guide/page, or
      //   /docs/ts/latest/guide/../cookbook/abc
      //
      let prefix = uriPathPrefix;
      while (href.startsWith('../')) {
        href = href.replace(/^..\//, '');
        prefix = path.dirname(prefix);
      }
      href = `${prefix}/${href}`;
    }

    if (fragment) href += `#${fragment}`;
    // console.error(` >> chalin '${href}'`);
    $(e).attr('href', href);
    // $(e).removeAttr('href')
    // $(e).attr('routerLink', href);
    // if (fragment) $(e).attr('fragment', fragment);
    // if (debugTrace) console.error(`      -> href=${href} fragment=${fragment}`);
  });
}

function execp(cmdAndArgs, options) {
  const cmd_and_args_arr = cmdAndArgs.split(' ');
  const pp = spawnExt(cmd_and_args_arr[0], cmd_and_args_arr.splice(1), options);
  return pp.promise;
}

function _sass(dir) {
  return gulp.src(`${dir}/**/*.scss`)
    .pipe(sass({ outputStyle: 'compressed' }).on('error', sass.logError))
    .pipe(gulp.dest(dir));
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

// Not currently used.

function _spawn(cmd, args, options) {
  const proc = spawn(cmd, args, options);

  proc.stdout.setEncoding('utf8');
  proc.stdout.on('data', data => gutil.log(data));
  proc.stderr.setEncoding('utf8');
  proc.stderr.on('data', data => console.error(data));
  // proc.on('close', (code) => {
  //   console.log(`child process exited with code ${code}`);
  // });
  return proc;
}

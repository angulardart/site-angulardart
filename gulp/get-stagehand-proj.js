'use strict';

module.exports = function (gulp, plugins, config) {

  const cp = plugins.child_process;
  const fs = plugins.fs;
  const path = plugins.path;
  const replace = plugins.replace;

  const EXAMPLES_PATH = config.EXAMPLES_PATH;

  // const qsProjName = config.qsProjName;
  const webSimpleProjPath = config.webSimpleProjPath;

  gulp.task('get-stagehand-proj', () => true);

  gulp.task('_disabled-for-now-get-stagehand-proj', cb => {
    const baseDir = webSimpleProjPath;
    if (plugins.argv.clean) cp.execSync(`rm -Rf ${baseDir}`);
    if (!fs.existsSync(baseDir)) cp.execSync(`./scripts/get-ng-web-angular.sh`);
    return gulp.src([
      `${baseDir}/analysis_options.yaml`,
      `${baseDir}/pubspec.yaml`,
      `${baseDir}/web/index.html`,
      `${baseDir}/web/main.dart`,
      `${baseDir}/lib/app_component.dart`
    ], { base: baseDir })
      // pubspec.yaml
      .pipe(replace(/^name: angular_app/, '# #docregion\n$&'))
      .pipe(replace(/(^description: )A simple AngularDart app/m, '$1QuickStart'))
      .pipe(replace(/^#(author|homepage).*\n/gm, ''))
      // index.html
      .pipe(replace(/^<!DOCTYPE html>/, '<!-- #docregion -->\n$&'))
      .pipe(replace(/(\s*)(<my-app>[^<]*<\/my-app>.*)/,
        '$1<!-- #docregion my-app -->$1$2$1<!-- #enddocregion my-app -->'))
      // *.dart
      // Remove (bogus) author from copyright notice.
      .pipe(replace(/^(\/\/ Copyright \(c\) 20\d\d)[^\.]*\./, '$1.'))
      // Add docregion after copyright notice.
      .pipe(replace(/^(\/\/ Copyright[\S\s]+\/\/ is governed by .*LICENSE file\.\n\n)/, '$1// #docregion\n'))
      // Fix @Component formatting in app_component.dart
      .pipe(replace(/^(@Component\()(selector: 'my-app',) (template:)/m, '$1\n  $2\n  $3'))
      .pipe(gulp.dest(path.join(EXAMPLES_PATH, 'quickstart')));
  });

};

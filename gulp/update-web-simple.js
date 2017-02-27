'use strict';

module.exports = function (gulp, plugins, config) {

  const cp = plugins.child_process;
  const fs = plugins.fs;
  const path = plugins.path;
  const replace = plugins.replace;

  const qsProjName = 'angular_quickstart';
  if (!process.env.TMP) {
    const msg = 'TMP environment variable is undefined.\n' +
      'Did you forget to: source ./scripts/env-set.sh?';
    console.log(msg);
    throw msg;
  }
  const webSimpleProjPath = path.join(process.env.TMP, qsProjName);

  gulp.task('update-web-simple', cb => {
    const baseDir = webSimpleProjPath;
    if (plugins.argv.clean) cp.execSync(`rm -Rf ${baseDir}`);
    if (!fs.existsSync(baseDir)) cp.execSync(`./scripts/get-ng-web-simple.sh`);
    return gulp.src([
      `${baseDir}/pubspec.yaml`,
      `${baseDir}/web/index.html`,
      `${baseDir}/web/main.dart`,
      `${baseDir}/lib/app_component.dart`
    ], { base: baseDir })
      // pubspec.yaml
      .pipe(replace(/^name: angular_quickstart/, '# #docregion\n$&'))
      .pipe(replace(/(^description: )A simple AngularDart app/m, '$1QuickStart'))
      .pipe(replace(/(^  angular2: \^).*/m, '$13.0.0-alpha'))
      // index.html
      .pipe(replace(/^<!DOCTYPE html>/, '<!-- #docregion -->\n$&'))
      .pipe(replace(/(\s*)(<my-app>[^<]*<\/my-app>.*)/,
        '$1<!-- #docregion my-app -->$1$2$1<!-- #enddocregion my-app -->'))
      // *.dart
      // Add docregion at top of file and remove (bogus) author from copyright notice.
      .pipe(replace(/^(\/\/ Copyright \(c\) 20\d\d)[^\.]*\./, '// #docregion\n$1.'))
      .pipe(gulp.dest('public/docs/_examples/quickstart/dart'));
  });

};

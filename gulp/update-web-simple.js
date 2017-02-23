'use strict';

module.exports = function (gulp, plugins, config) {

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
    return gulp.src([
      `${baseDir}/pubspec.yaml`,
      `${baseDir}/web/index.html`,
      `${baseDir}/web/main.dart`,
      `${baseDir}/lib/app_component.dart`
    ], { base: baseDir })
      // pubspec.yaml
      .pipe(replace(/^name: angular_quickstart/, '# #docregion\n$&'))
      // index.html
      .pipe(replace(/^<!DOCTYPE html>/, '<!-- #docregion -->\n$&'))
      .pipe(replace(/(\s*)(<my-app>[^<]*<\/my-app>.*)/,
        '$1<!-- #docregion my-app -->$1$2$1<!-- #enddocregion my-app -->'))
      // *.dart
      .pipe(replace(/^import 'package:angular.*/, '// #docregion\n$&'))
      .pipe(gulp.dest('public/docs/_examples/quickstart/dart'));
  });

};

// Gulp tasks related to updating the pubspec version of angular.
'use strict';

module.exports = function (gulp, plugins, config) {

  const EXAMPLES_PATH = config.EXAMPLES_PATH;
  const path = plugins.path;
  const replace = plugins.replace;

  const NG_VERS = '^3.0.0-beta';
  const depOvr = 'dependency_overrides:\n' +
    '  angular2:\n' +
    '    git: https://github.com/dart-lang/angular2.git\n';
  const depOvr2 = 'git:\n' +
    '      url: https://github.com/dart-lang/angular2.git\n' +
    '      ref: 3.0.0-alpha+1\n';

  gulp.task('update-ng-vers', ['_update-ng-vers', '_dep_overrides2']);

  gulp.task('_update-ng-vers', (cb) => {
    const baseDir = path.resolve(EXAMPLES_PATH, '..');
    return gulp.src([
      `${baseDir}/**/pubspec.yaml`,
      `!${baseDir}/**/.pub/**/pubspec.yaml`,
    ]) // , { base: baseDir }
      .pipe(replace(/angular2: ['"][^'"]+['"]/, `angular2: ${NG_VERS}`))
      .pipe(replace(/angular2: \^\S+/, `angular2: ${NG_VERS}`))
      .pipe(gulp.dest(baseDir));
  });

  gulp.task('_dep_overrides', ['_update-ng-vers'], (cb) => {
    const baseDir = path.resolve(EXAMPLES_PATH, '..');
    return gulp.src([
      `${baseDir}/**/pubspec.yaml`,
      `!${baseDir}/ng_test/github_issues/pubspec.yaml`,
      `!${baseDir}/**/.pub/**/pubspec.yaml`,
    ]) // , { base: baseDir }
      .pipe(replace(/\btransformers:/, `${depOvr}$&`))
      .pipe(gulp.dest(baseDir));
  });

  gulp.task('_dep_overrides2', ['_update-ng-vers'], (cb) => {
    const baseDir = path.resolve(EXAMPLES_PATH, '..');
    return gulp.src([
      `${baseDir}/**/pubspec.yaml`,
      `!${baseDir}/ng_test/github_issues/pubspec.yaml`,
      `!${baseDir}/**/.pub/**/pubspec.yaml`,
    ]) // , { base: baseDir }
      .pipe(replace('git: https://github.com/dart-lang/angular2.git', `${depOvr2}`))
      .pipe(gulp.dest(baseDir));
  });

};

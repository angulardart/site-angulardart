// Gulp tasks related to updating the pubspec version of angular & sdk
'use strict';

module.exports = function (gulp, plugins, config) {

  const EXAMPLES_PATH = config.EXAMPLES_PATH;
  const path = plugins.path;
  const replace = plugins.replace;

  gulp.task('update-pubspec', ['update-ng-vers', 'update-sdk-vers']);

  //---------------------------------------------------------------------------
  // Updating SDK version

  const SDK_VERS = '>=1.23.0-dev <2.0.0';

  gulp.task('update-sdk-vers', ['update-ng-vers'], (cb) => {
    const baseDir = path.resolve(EXAMPLES_PATH, '..');
    return gulp.src([
      `${baseDir}/**/pubspec.yaml`,
      `!${baseDir}/**/.pub/**`,
    ]) // , { base: baseDir }
      .pipe(replace(/^(\s+sdk): ['"][^'"]+['"]/m, `$1: '${SDK_VERS}'`))
      .pipe(gulp.dest(baseDir));
  });

  //---------------------------------------------------------------------------
  // Updating ACX and NG versions

  const ACX_VERS = '^0.4.1-beta';
  const NG_VERS = '^3.0.0-beta+1';
  const depOvr = 'dependency_overrides:\n' +
    '  angular2:\n' +
    '    git: https://github.com/dart-lang/angular2.git\n';
  const depOvr2 = 'git:\n' +
    '      url: https://github.com/dart-lang/angular2.git\n' +
    '      ref: 3.0.0-alpha+1\n';
  const depOvr3 = 'dependency_overrides:\n' +
    `  angular2:\n    ${depOvr2}\n`;

  gulp.task('update-ng-vers', ['_update-acx-vers', '_update-ng-vers', '_remove_dep_overrides']);

  gulp.task('_update-acx-vers', (cb) => {
    const baseDir = path.resolve(EXAMPLES_PATH, '..');
    return gulp.src([
      `${baseDir}/**/pubspec.yaml`,
      `!${baseDir}/**/.pub/**`,
    ]) // , { base: baseDir }
      .pipe(replace(/(angular2_components): ['"][^'"]+['"]/, `$1: ${ACX_VERS}`))
      .pipe(replace(/(angular2_components): \^\S+/, `$1: ${ACX_VERS}`))
      .pipe(gulp.dest(baseDir));
  });

  gulp.task('_update-ng-vers', ['_update-acx-vers'], (cb) => {
    const baseDir = path.resolve(EXAMPLES_PATH, '..');
    return gulp.src([
      `${baseDir}/**/pubspec.yaml`,
      `!${baseDir}/**/.pub/**`,
    ]) // , { base: baseDir }
      .pipe(replace(/angular2: ['"][^'"]+['"]/, `angular2: ${NG_VERS}`))
      .pipe(replace(/angular2: \^\S+/, `angular2: ${NG_VERS}`))
      .pipe(gulp.dest(baseDir));
  });

  gulp.task('_dep_overrides', ['_update-acx-vers', '_update-ng-vers'], (cb) => {
    const baseDir = path.resolve(EXAMPLES_PATH, '..');
    return gulp.src([
      `${baseDir}/**/pubspec.yaml`,
      `!${baseDir}/ng_test/github_issues/pubspec.yaml`,
      `!${baseDir}/**/.pub/**`,
    ]) // , { base: baseDir }
      .pipe(replace(/\btransformers:/, `${depOvr}$&`))
      .pipe(gulp.dest(baseDir));
  });

  gulp.task('_dep_overrides2', ['_update-acx-vers', '_update-ng-vers'], (cb) => {
    const baseDir = path.resolve(EXAMPLES_PATH, '..');
    return gulp.src([
      `${baseDir}/**/pubspec.yaml`,
      `!${baseDir}/ng_test/github_issues/pubspec.yaml`,
      `!${baseDir}/**/.pub/**`,
    ]) // , { base: baseDir }
      .pipe(replace('git: https://github.com/dart-lang/angular2.git', `${depOvr2}`))
      .pipe(gulp.dest(baseDir));
  });

  gulp.task('_remove_dep_overrides', ['_update-acx-vers', '_update-ng-vers'], (cb) => {
    const baseDir = path.resolve(EXAMPLES_PATH, '..');
    return gulp.src([
      `${baseDir}/**/pubspec.yaml`,
      `!${baseDir}/ng_test/github_issues/pubspec.yaml`,
      `!${baseDir}/**/.pub/**`,
    ]) // , { base: baseDir }
      .pipe(replace(depOvr3, ''))
      .pipe(gulp.dest(baseDir));
  });

};

'use strict';

module.exports = function(gulp, plugins, config) {

  const sass = require('gulp-sass');

  gulp.task('sass', cb => _sass('src'));

  function _sass(dir) {
    const opt = plugins.argv.prod ? { outputStyle: 'compressed' } : {};
    return gulp.src([
      `${dir}/**/*.scss`,
      `!${dir}/_assets/**/*.scss`
    ])
      .pipe(sass(opt).on('error', sass.logError))
      .pipe(gulp.dest(dir));
  }

};
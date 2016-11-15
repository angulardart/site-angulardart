module.exports = function(gulp, plugins, config) {

  const sass = require('gulp-sass');

  gulp.task('sass', cb => _sass('src'));

  function _sass(dir) {
    return gulp.src([
      `${dir}/**/*.scss`,
      `!${dir}/_assets/**/*.scss`
    ])
      .pipe(sass({ outputStyle: 'compressed' }).on('error', sass.logError))
      .pipe(gulp.dest(dir));
  }

};
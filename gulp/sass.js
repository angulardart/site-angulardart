module.exports = function(gulp, plugins, config) {

  const sass = require('gulp-sass');

  gulp.task('sass', cb => _sass('src/styles'));

  function _sass(dir) {
    return gulp.src(`${dir}/**/*.scss`)
      .pipe(sass({ outputStyle: 'compressed' }).on('error', sass.logError))
      .pipe(gulp.dest(dir));
  }

};
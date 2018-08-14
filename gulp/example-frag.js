// Gulp tasks related to creating sample code fragments.
'use strict';

module.exports = function (gulp, plugins, config) {
  function _cleanFrag() { return plugins.delFv(config.frags.path) }

  gulp.task('_clean-frag', _cleanFrag);

  function _createFrag(done) {
    plugins.execSyncAndLog(`./scripts/refresh-code-excerpts.sh`);
    done();
  }

  gulp.task('create-example-fragments', gulp.series(_cleanFrag, _createFrag));
};

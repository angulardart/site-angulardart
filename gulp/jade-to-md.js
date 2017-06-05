// Gulp Jade-to-Markdown helper tasks.
//
// Note that the main task only operates on the file content, it doesn't rename
// the file (this makes it easier to view diffs). The code_excerpt_updater must
// also be run separately.
'use strict';

module.exports = function (gulp, plugins, config) {

  const NgIoUtil = require('../src/resources/js/util.js').NgIoUtil;
  const argv = plugins.argv;
  const replace = plugins.replace;

  function mkExcerptPER(match, instr, path, excerptText, regionFromExcerpt, dontcare, region, notitle) {
    const dartPath = NgIoUtil.adjustTsExamplePathForDart(path);
    const titleAttr = notitle ? '' : ' title';
    const regionAttr = region ? ` region="${region}"` : '';
    const linenumsAttr = instr === 'Example' ? ' linenums' : '';
    return `<?code-excerpt "${dartPath}${excerptText || ''}"${regionAttr}${titleAttr}${linenumsAttr}?>\n`
      + '```\n\n```';
  }

  function filetree(match, args) {
    const ul = args
      .replace(/^\s*\.children\n/gm, '')
      .replace(/\.file/g, '-');
    return `<div class="ul-filetree" markdown="1">\n${ul}</div>\n`
  }

  function subsection(match, text) {
    return `\n<div class="l-sub-section" markdown="1">\n${text}</div>\n`
  }

  let frontMatterMarkerCount = 0;
  function unindent(match, linePrefix) {
    if (linePrefix === '---') {
      frontMatterMarkerCount++;
      return match;
    }
    return frontMatterMarkerCount >= 2 ? '' : match;
  }

  // Arguments:
  // --file=<file-glob> relative to src/angular
  // --no-unindent      to disable the unindent feature.
  gulp.task('jade-to-md', () => {
    const baseDir = 'src/angular';
    if (!argv.file) throw `jade-to-md requires a --file glob argument, relative to ${baseDir}.`;
    let targets = argv.file.replace(/^\//, '');
    if (!targets.endsWith('.jade')) throw `--file glob must end in '.jade'`;
    return gulp.src([
      `${baseDir}/${targets}`,
    ], { base: baseDir })
      .pipe(replace(/^\/\/- (FilePath: [^\.]+)\.jade$/m, '<!-- $1.md -->'))
      .pipe(replace(/^(\.l-main-section|:marked)\n/mg, ''))
      .pipe(replace(/\n\.l-sub-section\n(( +[^\n]+\n)+)/g, subsection))
      .pipe(argv.unindent === false ? plugins.gutil.noop() : replace(/^(---|  )/mg, unindent))
      .pipe(replace(/\+make(Example|Excerpt)\('([^'\(]+)( \(([^\)']+)\))?'(, '([^']+)'(, '')?)?\)/g, mkExcerptPER))
      .pipe(replace(/\.filetree\n((\s*\..*\n)+)/g, filetree))
      .pipe(replace(/^include (.+)/mg, '{% include_relative $1.md %}'))
      .pipe(gulp.dest(baseDir));
  });

};

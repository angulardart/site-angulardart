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
    if (excerptText === ' ()') excerptText = ' (excerpt)';
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

  function subsection(match, classes, text) {
    classes = classes.replace(/^\./, '').replace('.', ' ');
    text = text.replace(/^\s+:marked\n/mg, '');
    return `\n<div class="${classes}" markdown="1">\n${text}</div>\n`
  }

  let frontMatterMarkerCount = 0;
  function unindent(match, linePrefix) {
    if (linePrefix === '---') {
      frontMatterMarkerCount++;
      return match;
    }
    return frontMatterMarkerCount >= 2 ? '' : match;
  }

  function abbrValue(key) {
    const _FutureUrl = 'https://api.dartlang.org/dart_async/Future.html';
    switch(key) {
      case '_docsFor': return 'dart';
      case '_decorator': return 'annotation';
      case '_Array': return 'List';
      case '_array': return 'list';
      case '_a': return 'an';
      case '_an': return 'a';
      case '_priv': return '_';
      case '_Lang': return 'Dart';
      case '_Promise': return 'Future';
      case '_FutureUrl': return _FutureUrl;
      case '_PromiseLinked': return `<a href="${_FutureUrl}">Future</a>`;
      case '_Observable': return 'Stream';
      case '_liveLink': return 'sample repo';
      case '_truthy': return 'true';
      case '_falsy': return 'false';
      case '_appDir': return 'lib';
      case '_indexHtmlDir': return 'web';
      case '_mainDir': return 'web';
      default: return null;
    }
  }

  function abbr(match, leadingChar, key) {
    const val = abbrValue(key);
    return val ? `${leadingChar}${val}` : match[0];
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
      .pipe(replace(/\+ifDocsFor\('ts'\)\n\s*:marked\n(\s*\n|\s+[^\n]+\n)*/g, ''))
      .pipe(replace(/^(\.l-main-section|:marked|include .*_util-fns(.jade)?)\n/mg, ''))
      .pipe(replace(/^\.l-main-section#(\S+)/mg, '<a id="$1"></a>'))
      .pipe(replace(/^a?#(\w+)/mg, '<a id="$1"></a>'))
      .pipe(replace(/\n(\.alert.*|\.callout.*|\.l-sub-section)\n(( +[^\n]+\n)+)/g, subsection))
      .pipe(argv.unindent === false ? plugins.gutil.noop() : replace(/^(---|  )/mg, unindent))
      .pipe(replace(/\+make(Example|Excerpt)\('([^'\(]+)( \(([^\)']*)\))?'(, '([^']+)'(, '')?)?\)/g, mkExcerptPER))
      .pipe(replace(/\.filetree\n((\s*\..*\n)+)/g, filetree))
      .pipe(replace(/^include (.+)/mg, '{% include_relative $1.md %}'))
      .pipe(replace(/^figure.image-display\n\s*img\(((\s*\w+="[^"]+")+)\)/mg, '<img $1>'))
      .pipe(replace(/([^{])!{([_\w]+)}/g, abbr))
      .pipe(gulp.dest(baseDir));
  });

};

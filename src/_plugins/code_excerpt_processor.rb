##
## Classes that support the processing of <?code-excerpt?> and
## <?code-pane?> instructions.
##

require 'open3'
require 'nokogiri'

module NgCodeExcerpt

  class MarkdownProcessor

    @@logFileName = 'code-excerpt-log.txt'
    @@logDiffs = false
    @@logEntryCount = 0

    File.delete(@@logFileName) if File.exists?(@@logFileName)

    def codeExcerptRE
      /^(\s*(<\?(code-\w+)[^>]*>)\n)((\s*)```(\w*)\n(.*?)\n(\s*)```\n?)?/m;
    end

    def codeExcerptProcessingInit()
      @pathBase = ''
    end

    def processCodeExcerpt(match, templateLang)
      # piLineWithWhitespace = match[1]
      pi = match[2] # full processing instruction <?code-excerpt...?>
      piName = match[3]
      args = processPiArgs(pi)
      optionalCodeBlock = match[4]
      indent = match[5]
      lang = !match[6] || match[6].empty? ? (args['ext'] || 'nocode') : match[6]
      attrs = mkCodeExampleDirectiveAttributes(lang, args['linenums'])

      if piName == 'code-pane'
        return processCodePane(pi, attrs, args)
      elsif piName != 'code-excerpt'
        logPuts "Warning: unrecognized instruction: #{pi}"
        return match[0]
      elsif !optionalCodeBlock
        # w/o a code block assume it is a set cmd
        processSetCommand(pi, args)
        return ''
      elsif lang == 'diff'
        return _diff(match[7], args)
      end

      title = args['title']
      classes = args['class']
      code = match[7]

      code = trimMinLeadingSpace(code)

      # We escape all code fragments (not just HTML fragments),
      # because we're rendering the code block as HTML.
      escapedCode = CGI::escapeHTML(code)

      return codeExcerpt(title, classes, attrs, _processHighlightMarkers(escapedCode), indent)
    end

    def codeExcerpt(title, classes, attrs, escapedCode, indent)
      result = _unindentedTemplate(title, classes, attrs, escapedCode)
      # For markdown, indent at most the first line (in particular, we don't want to indent the code)
      result.sub!(/^/, indent) if indent
      return result
    end

    def _diff(unifiedDiffText, args)
      logPuts "Diff input:\n#{unifiedDiffText}" if @@logDiffs
      begin
        o, e, s = Open3.capture3("diff2html --su hidden -i stdin -o stdout", :stdin_data => unifiedDiffText)
        logPuts e if e.length > 0
      rescue Errno::ENOENT => e
        raise "** ERROR: diff2html isn't installed or could not be found. " +
              "To install with NPM run: npm install -g diff2html-cli"
      end
      doc = Nokogiri::HTML(o)
      doc.css('div.d2h-file-header span.d2h-tag').remove
      diffHtml = doc.search('.d2h-wrapper')
      _trimDiff(diffHtml, args) if args['from'] || args['to']
      logPuts "Diff output:\n#{diffHtml.to_s[0, [diffHtml.to_s.length, 100].min]}...\n" if @@logDiffs
      return diffHtml.to_s
    end

    def _processHighlightMarkers(s)
      s.gsub(/\[!/, '<span class="highlight">')
       .gsub(/!\]/, '</span>')
    end

    def _trimDiff(diffHtml, args)
      # The code updater truncates the diff after `to`. Only trim before `from` here.
      # (We don't trim after `to` here because of an unwanted optimizing behavior of diff2html.)
      logPuts ">>> from='#{args['from']}' to='#{args['to']}'" if @@logDiffs
      insideMatchingLines = done = false;
      diffHtml.css('tbody.d2h-diff-tbody tr').each do |tr|
        if tr.text.strip.start_with?('@')
          tr.remove
          next
        end
        codeLine = tr.xpath('td[2]//span').text
        insideMatchingLines = true if !done && !insideMatchingLines && codeLine.match(args['from'] || '.')
        savedInsideMatchingLines = insideMatchingLines
        # if insideMatchingLines && args['to'] && codeLine.match(args['to'])
        #   insideMatchingLines = false
        #   done = true;
        # end
        logPuts ">>> tr (#{savedInsideMatchingLines}) #{codeLine} -> #{tr.text.gsub(/\s+/, ' ')}" if @@logDiffs
        tr.remove unless savedInsideMatchingLines;
      end
    end

    def _unindentedTemplate(title, classes, attrs, escapedCode)
      "<div class=\"code-example #{classes || ''}\">\n" +
        (title ? "<header><h4>#{title}</h4></header>\n" : '') +
        "<code-example data-webdev-raw #{attrs}>" +
          escapedCode +
        "</code-example>\n" +
      "</div>\n"
    end

    def trimMinLeadingSpace(code)
      lines = code.split(/\n/);
      nonblanklines = lines.reject { |s| s.match(/^\s*$/) }

      # Length of leading spaces to be trimmed
      len = nonblanklines.map{ |s|
          matches = s.match(/^[ \t]*/)
          matches ? matches[0].length : 0 }.min

      return len == 0 ? code :
        lines.map{|s| s.length < len ? s : s[len..-1]}.join("\n")
    end


    def mkCodeExampleDirectiveAttributes(lang, linenums)
      formats = linenums ? ['linenums'] : [];
      formats.push('nocode') if lang == 'nocode'
      attrs = []
      attrs.push("language=\"#{lang}\"") unless lang == 'nocode'
      attrs.push("format=\"#{formats * ' '}\"") if !formats.empty?
      return attrs * ' '
    end

    def processPiArgs(pi)
      # match = /<\?code-\w+\s*(("([^"]*)")?((\s+[-\w]+="[^"]*"\s*)*))\?>/.match(pi)
      match = /<\?code-\w+\s*(.*?)\s*\?>/.match(pi)
      if !match
          logPuts "ERROR: improperly formatted instruction: #{pi}"
          return nil
      end

      argString = match[1]
      args = { }

      # First argument can be unnamed. When present, it is saved as
      # args['']. It is used to define a path and an optional region.
      match = /^"(([^\("]*)(\s+\(([^"]+)\))?)"/.match(argString)
      if match
        argString = $' # reset to remaining args
        args[''] = match[1]
        path = args['path'] = match[2]
        args['ext'] = File.extname(path)&.sub(/^\./,'')
        args['region'] = match[4]&.gsub(/[^\w]+/, '-') || ''
      end

      # Process remaining args
      argString.scan(/\b(\w[-\w]*)(="([^"]*)")?/) { |id,arg,val|
        if id == 'title' && !arg then val = trimFileVers(args['']) end
        args[id] = val || ''
      }
      # puts "  >> args: #{args}"
      return args
    end

    def processCodePane(pi, attrs, args)
      title = args['title'] || trimFileVers(args[''])
      escapedCode = getCodeFrag(
        fullFragPath(args['path'], args['region']),
        srcPath(args['path'], args['region']),
        args['region'])
      # args['replace'] syntax: /regex/replacement/g
      # Replacement and 'g' are currently mandatory (but not checked)
      if args['replace']
        _, re, replacement, g = args['replace'].split '/'
        escapedCode.gsub!(Regexp.new(re)) {
          match = Regexp.last_match
          # TODO: add support for $1, $2, ..., and $$ (escaped $).
          if /\$(\$|\d)/ =~ replacement
            raise "plugin support for $$, $1, $2, ... has not been implemented yet"
          end
          if replacement.include? '$&'
            replacement.gsub('$&', match[0])
          else
            replacement
          end
        }
      end
      result =
      "#{pi}\n" +
      "<code-pane name=\"#{title}\" #{attrs}>" +
        _processHighlightMarkers(escapedCode) +
      "</code-pane>\n"
      # logPuts ">> code-pane:\n#{result}\n"
      return result
    end

    def processSetCommand(pi, args)
      # Ignore all commands other than path-base.
      pathBase = args['path-base'];
      return unless pathBase;
      @pathBase = pathBase.sub(/\/$/, '');
      # puts ">> path base set to #{@pathBase}"
    end

    def getCodeFrag(fragPath, srcPath, region)
      if File.exists? fragPath
        lines = File.readlines fragPath
        result = escapeAndTrimCode(lines)
      elsif srcPath && (File.exists? srcPath)
        lines = File.readlines srcPath
        result = escapeAndTrimCode(lines)
      else
        result = "BAD FILENAME: #{fragPath}"
        result += " (#{srcPath})" if region == ''
        logPuts result
      end
      return result
    end

    def fullFragPath(projRelPath, region)
      fragRelPath = File.join(@pathBase, projRelPath)
      if region && !region.empty?
        dir = File.dirname(fragRelPath)
        basename = File.basename(fragRelPath, '.*')
        ext = File.extname(fragRelPath)
        fragRelPath = File.join(dir, "#{basename}-#{region}#{ext}")
      end
      fragExtension = '.txt'
      fullPath = File.join(Dir.pwd, 'tmp', '_fragments', fragRelPath + fragExtension)
    end

    def srcPath(projRelPath, region)
      region == '' ? File.join(@pathBase, projRelPath) : nil
    end

    def escapeAndTrimCode(lines)
      # Skip blank lines at the end too
      while !lines.empty? && lines.last.strip == '' do lines.pop end
      return CGI::escapeHTML(lines.join)
    end

    def logPuts(s)
      puts(s)
      fileMode = (@@logEntryCount += 1) <= 1 ? 'w' : 'a'
      File.open(@@logFileName, fileMode) do |logFile| logFile.puts(s) end
    end

    def trimFileVers(s)
      # Path/title like styles.1.css or foo_1.dart? Then drop the '.1' or '_1' qualifier:
      match = /^(.*)[\._]\d(\.\w+)(\s+.+)?$/.match(s)
      s = "#{match[1]}#{match[2]}#{match[3]}" if match
      return s
    end

  end

  class JadeMarkdownProcessor < MarkdownProcessor

    def codeExcerpt(title, classes, attrs, escapedCode, indent)
      # Unindent by 2 spaces so as to get out of current
      # `:marked` region, since the code-excerpt will be a
      # separate (non-markdown) Jade region.
      indent.sub!(/^  /,'') if indent;
      return super(title, classes, attrs, escapedCode, indent)
    end

    def _unindentedTemplate(title, classes, attrs, escapedCode)
      classes = '.' + classes.sub(/\s+/, '.') if classes
      ".code-example#{classes}\n" +
      (title ? "  header: h4 #{title}\n" : '') +
      "  code-example(#{attrs}).\n" +
      "#{escapedCode.gsub(/^/, '    ')}\n" +
      ":marked"
    end

  end
end

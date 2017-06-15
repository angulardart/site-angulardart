##
## Classes that support the processing of <?code-excerpt?> and
## <?code-pane?> instructions.
##

module NgCodeExcerpt

  class MarkdownProcessor

    @@logEntryCount = 0;

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
      args = processPiArgs(pi);
      optionalCodeBlock = match[4]
      indent = match[5]
      lang = !match[6] || match[6].empty? ? (args['ext'] || 'nocode') : match[6]
      attrs = mkCodeExampleDirectiveAttributes(lang, args['linenums'] || piName == 'code-pane')

      if piName == 'code-pane'
        return processCodePane(pi, attrs, args)
      elsif piName != 'code-excerpt'
        logPuts "Warning: unrecognized instruction: #{pi}"
        return match[0]
      elsif !optionalCodeBlock
        # w/o a code block assume it is a set cmd
        processSetCommand(pi, args)
        return ''
      end

      title = args['title']
      classes = args['class']
      code = match[7]

      code = trimMinLeadingSpace(code)

      # We escape all code fragments (not just HTML fragments),
      # because we're rendering the code block as HTML.
      escapedCode = CGI::escapeHTML(code)

      # Handle highlighting
      escapedCode.gsub!(/\[!/, '<span class="highlight">')
      escapedCode.gsub!(/!\]/, '</span>')

      return codeExcerpt(title, classes, attrs, escapedCode, indent)
    end

    def codeExcerpt(title, classes, attrs, escapedCode, indent)
      result = _unindentedTemplate(title, classes, attrs, escapedCode)
      # For markdown, indent at most the first line (in particular, we don't want to indent the code)
      result.sub!(/^/, indent) if indent
      return result
    end

    def _unindentedTemplate(title, classes, attrs, escapedCode)
      "<div class=\"code-example #{classes || ''}\">\n" +
        (title ? "<header><h4>#{title}</h4></header>\n" : '') +
        "<code-example #{attrs}>" +
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
      # match = /<\?code-\w+\s*(("([^"]*)")?((\s+[-\w]+="[^"]*"\s*)*))\??>/.match(pi)
      match = /<\?code-\w+\s*([^\?>]*)\s*\??>/.match(pi)
      if !match
          puts "ERROR: improperly formatted instruction: #{pi}"
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
        args['region'] = match[4]&.gsub(/[^\w]+/, '-')
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
      escapedCode = getCodeFrag(fullFragPath(args['path'], args['region']))
      result =
      "#{pi}\n" +
      "<code-pane name=\"#{title}\" #{attrs}>" +
        escapedCode +
      "</code-pane>\n"
      # puts ">> code-pane:\n#{result}\n"
      return result
    end
    
    def processSetCommand(pi, args)
      pathBase = nil
      if !args || !(pathBase = args['path-base'])
        puts "ERROR: code block expected immediately after #{pi}"
        return;
      end
      @pathBase = pathBase.sub(/\/$/, '');
      # puts ">> path base set to #{@pathBase}"
    end
  
    def getCodeFrag(path)
      if File.exists? path
        lines = File.readlines path
        result = escapeAndTrimCode(lines)
      else
        result = "BAD FILENAME: #{path}"
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

    def escapeAndTrimCode(lines)
      # Skip blank lines at the end too
      while !lines.empty? && lines.last.strip == '' do lines.pop end
      return CGI::escapeHTML(lines.join)
    end

    def logPuts(s)
      puts(s)
      fileMode = (@@logEntryCount += 1) <= 1 ? 'w' : 'a'
      File.open('code-excerpt-log.txt', fileMode) do |logFile| logFile.puts(s) end
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

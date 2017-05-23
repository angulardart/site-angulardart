##
## Classes that support the processing of <?code-excerpt?> instructions.
##

module NgCodeExcerpt

  class MarkdownProcessor
    def codeExcerptRE
      /^(\s*(<\?code-excerpt[^>]+\??>)\n)((\s*)```(\w*)\n(.*?)\n(\s*)```\n?)?/m;
    end

    def codeExcerptProcessingInit()
      @pathBase = ''
    end

    def processCodeExcerpt(match, templateLang)
      piLine = match[1]
      pi = match[2] # processing instruction <?code-excerpt ...?>
      args = processPiArgs(pi);
      optionalCodeBlock = match[3]
      if !optionalCodeBlock
        # w/o a code block assume it is a set cmd
        processSetCommand(pi, args)
        return ''
      end

      title = args['title']
      indent = match[4]
      lang = match[5].empty? ? args['ext'] : match[5];
      format = getCodeExampleFormat(lang)
      code = match[6]

      # Indented code bocks are easier to read in markdown, but they affect layout.
      # If the first line is indented by 2 spaces, trim out that indentation.
      code.gsub!(/^  /m, '') if code.start_with?('  ')

      # We escape all code fragments (not just HTML fragments),
      # because we're rendering the code block as HTML.
      escapedCode = CGI::escapeHTML(code)

      # Handle highlighting
      escapedCode.gsub!(/\[!/, '<span class="highlight">')
      escapedCode.gsub!(/!\]/, '</span>')

      return codeExcerpt(title, format, escapedCode, indent)
    end

    def codeExcerpt(title, format, escapedCode, indent)
      result = _unindentedTemplate(title, format, escapedCode)
      result.gsub!(/^/, indent) if indent
      return result
    end

    def _unindentedTemplate(title, format, escapedCode)
      "<div class=\"code-example\">\n" +
        (title ? "<header><h4>#{title}</h4></header>\n" : '') +
        "<code-example #{format}>" +
          escapedCode +
        "</code-example>\n" +
      "</div>\n"
    end

    def getCodeExampleFormat(lang)
      !lang || lang.empty? || lang == 'nocode' ? "format=\"nocode\"" : "language=\"#{lang}\""
    end

    def processPiArgs(pi)
      # match = /<\?code-excerpt\s*(("([^"]*)")?((\s+[-\w]+="[^"]*"\s*)*))\??>/.match(pi)
      match = /<\?code-excerpt\s*([^\?>]+)\s*\??>/.match(pi)
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
        val = args[''] if id == 'title' && !arg
        args[id] = val
      }
      # puts "  >> args: #{args}"
      return args
    end

    def processSetCommand(pi, args)
      pathBase = nil
      if !args || !(pathBase = args['path-base'])
        puts "ERROR: code block expected immediately after #{pi}"
      end
      @pathBase = pathBase.sub(/\/$/, '');
      # puts ">> path base set to #{@pathBase}"
    end
  end

  class JadeMarkdownProcessor < MarkdownProcessor

    def codeExcerpt(title, format, escapedCode, indent)
      # Unindent by 2 spaces so as to get out of current
      # `:marked` region, since the code-excerpt will be a
      # separate (non-markdown) Jade region.
      indent.sub!(/^  /,'') if indent;
      return super(title, format, escapedCode, indent)
    end

    def _unindentedTemplate(title, format, escapedCode)
      ".code-example\n" +
      (title ? "  header: h4 #{title}\n" : '') +
      "  code-example(#{format}).\n" +
      "#{escapedCode.gsub(/^/, '    ')}\n" +
      ":marked"
    end

  end
end

##
## Kramdown plugin extension.
##
## Converts code blocks preceded by a processing instruction (PI) of the form
## <?code-excerpt?> into <code-example> elements suitable for use in Angular docs.
##

require 'cgi'

module Jekyll
  class NgMarkdown < Jekyll::Converter

    def matches(ext)
      ext =~ /^\.md$/i
    end

    def output_ext(ext)
      ".html"
    end

    def convert(content)
        # puts ">>> NgMarkdown.convert() called"
        @pathBase = ''
        content.gsub!(/(<\?code-excerpt[^>]+\??>)\n((\s*)```(\w*)\n(.*?)\n```\n?)?/m) {
          processCodeExcerpt(Regexp.last_match)
        }
        if !@kramdownConverter
          @kramdownConverter = Jekyll::Converters::Markdown::KramdownParser.new(@config)
        end
        mkconverter = @kramdownConverter
        return mkconverter.convert(content)
    end

    def processCodeExcerpt(match)
      pi = match[1] # processing instruction <?code-excerpt ...?>
      args = processPiArgs(pi);
      optionalCodeBlock = match[2]
      if !optionalCodeBlock
        # w/o a code block assume it is a set cmd
        return processSetCommand(pi, args)
      end

      title = args['title']
      indent = match[3]
      lang = !match[4] || match[4].empty? ? args['ext'] : nil;
      format = getCodeExampleFormat(lang)
      code = match[5]

      # Indented code bocks are easier to read in markdown, but they affect layout.
      # If the first line is indented by 2 spaces, trim out that indentation.
      code.gsub!(/^  /m, '') if code.start_with?('  ')

      # We escape all code (not just HTML), because we're rendering
      # the code block as HTML.
      escapedCode = CGI::escapeHTML(code)

      # Handle highlighting
      escapedCode.gsub!(/\[!/, '<span class="highlight">')
      escapedCode.gsub!(/!\]/, '</span>')
      result = (
        "<div class=\"code-example\">\n" +
          (title ? "<header><h4>#{title}</h4></header>\n" : '') +
          "<code-example #{format}>" +
            escapedCode +
          "</code-example>\n" +
        "</div>\n")
      result.gsub!(/^/, indent) if indent
      # puts ">> #{result}"
      return result
    end

    def getCodeExampleFormat(lang)
      !lang || lang == 'nocode' ? "format=\"nocode\"" : "language=\"#{lang}\""
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
        return
      end
      @pathBase = pathBase.sub(/\/$/, '');
      # puts ">> path base set to #{@pathBase}"
      return pi;
    end

  end
end
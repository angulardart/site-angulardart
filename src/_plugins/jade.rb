##
## Plugin for converting Jade pages. It also:
##
## - Inserts code excerpts (required by makeExample, makeExcerpt, and makeTabs).
## - Supports the <?code-excerpt?> processing instruction.
##

require 'cgi'
require 'open3'
require_relative 'code_excerpt_processor'

module Jekyll

  class JadeConverter < Converter

    @@jadeLogEntryCount = 0;

    def matches(ext)
      ext =~ /^\.jade$/i
    end

    def output_ext(ext)
      ".html"
    end

    # Strip openning and closing ``` lines.
    def stripMdCodeMarkers(lines)
      # Skip first line (which is just the opening ```)
      lines.shift
      # Working from the end, skip until, and including, the ending ```
      while !lines.empty? && !(lines.pop =~ /^\s*```\s*$/) do end
      # Skip blank lines at the end too
      while !lines.empty? && lines.last.strip == '' do lines.pop end
      return CGI::escapeHTML(lines.join)
    end

    def logPuts(s)
      puts(s)
      fileMode = (@@jadeLogEntryCount += 1) <= 1 ? 'w' : 'a'
      File.open('jade-log.txt', fileMode) do |logFile| logFile.puts(s) end
    end

    def getCodeFrag(path)
      path2frag = File.join Dir.pwd, "tmp", path
      if File.exists? path2frag
        lines = File.readlines path2frag
        result = stripMdCodeMarkers(lines)
      else
        result = "BAD FILENAME: #{path2frag}"
        logPuts result
      end
      return result
    end

    def convert(content)
      begin
        # Unescape {!{ ... }!} back to Angular {{ }}
        content.gsub!(/{!{/, '{{') # &#123;&#123;
        content.gsub!(/}!}/, '}}') # &#125;&#125;

        # Process code excerpts
        @cep = NgCodeExcerpt::JadeMarkdownProcessor.new() unless @cep
        @cep.codeExcerptProcessingInit()
        content.gsub!(@cep.codeExcerptRE) {
          @cep.processCodeExcerpt(Regexp.last_match, 'jade')
        }
        # logPuts '>>>> File after PI processing: **************************************'
        # logPuts content
        # logPuts '>>>> ****************************************************************'

        # Process Jade
        matches = /- FilePath: (\S+)/.match(content);
        filePath = matches ? matches[1] : 'src/angular/unknown-file.jade'
        baseNoExt = File.basename(filePath, '.jade')
        dir = File.dirname(filePath).split('/')
        path = [ "docs", "dart", "latest"]
        path.push(*dir, baseNoExt)
        # obj = '{"current": {"source": "jade-src-uninit", "pathToDocs": "./", "path":["docs","dart","latest","jade-path-uninit"]}}'
        obj = {"basedir": File.join(Dir.pwd, "src/angular"), "current": {"source": baseNoExt, "pathToDocs": "./", "path": path}}
        obj_s = obj.to_s.gsub(/:(\w+)=>/, '\1: ')
        # puts "Got filepath #{filePath}\nobj = #{obj_s}"
        o, e, s = Open3.capture3("./node_modules/.bin/jade --path #{filePath} --obj '#{obj_s}'", :stdin_data => content)
        logPuts e if e.length > 0
      rescue Errno::ENOENT => e
        puts "** ERROR: Jade isn't installed or could not be found."
        puts "** ERROR: To install with NPM run: npm install jade -g"
        return nil
      end
      if baseNoExt == 'index'
        # E.g. for guide/index.html: relative URL "./foo" -> "guide/./foo"
        o.gsub!(/(href=")([^"]*)(")/) { _adjustRelativeHref(dir[-1], Regexp.last_match) }
      end
      o.gsub!(/!= partial\("([^"]+)"\)/) { getCodeFrag(Regexp.last_match[1]) }
      return o
    end

    def _adjustRelativeHref(dir, last_match)
      hrefOpen, url, hrefEnd = last_match[1], last_match[2], last_match[3]
      if url.start_with?('http', '#', '/')
        # puts " >> skipping url #{url}"
        return last_match[0]
      end
      newHref = "#{hrefOpen}#{dir}/#{url}#{hrefEnd}"
      # puts " >> new href #{newHref}"
      return newHref
    end
  end
end


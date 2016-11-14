##
## This Plugin enables Jade support to pages and posts.
##

require 'open3'
require 'cgi'

module Jekyll

  class JadeConverter < Converter

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

    def getCodeFrag(path)
      path2frag = File.join Dir.pwd, "src/angular", path
      if File.exists? path2frag
        lines = File.readlines path2frag
        result = stripMdCodeMarkers(lines)
      else
        result = "BAD FILENAME: #{path2frag}"
        puts result
      end
      return result
    end

    def convert(content)
      begin
        obj = '{"current": {"source": "jade-src-uninit", "pathToDocs": "./", "path":["docs","dart","latest","jade-path-uninit"]}}'
        o, e, s = Open3.capture3("./node_modules/.bin/jade --path src/angular/foo --obj '#{obj}'", :stdin_data => content)
        puts(<<-eos
Jade Error >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#{e}
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Jade Error
        eos
        ) if e.length > 0
      rescue Errno::ENOENT => e
        puts "** ERROR: Jade isn't installed or could not be found."
        puts "** ERROR: To install with NPM run: npm install jade -g"
        return nil
      end
      o.gsub!(/!= partial\("([^"]+)"\)/) { getCodeFrag(Regexp.last_match[1]) }
      return o
    end

  end

end


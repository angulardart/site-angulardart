##
## Kramdown plugin extension.
##
## Converts code blocks preceded by a processing instruction (PI) of the form
## <?code-excerpt?> into <code-example> elements suitable for use in Angular docs.
##

require 'cgi'
require_relative 'code_excerpt_processor'

module Jekyll

  class NgMarkdown < Converter

    priority :high

    def matches(ext)
      ext =~ /^\.md$/i
    end

    def output_ext(ext)
      ".html"
    end

    def convert(content)
      # Unescape {!{ ... }!} back to Angular {{ }}
      content.gsub!(/{!{/, '{{') # &#123;&#123;
      content.gsub!(/}!}/, '}}') # &#125;&#125;

      @cep = NgCodeExcerpt::MarkdownProcessor.new() unless @cep
      @cep.codeExcerptProcessingInit()
      content.gsub!(@cep.codeExcerptRE) {
        @cep.processCodeExcerpt(Regexp.last_match, 'markdown')
      }

      @baseConv = Converters::Markdown::KramdownParser.new(@config) unless @baseConv
      return @baseConv.convert(content)
    end

  end
end
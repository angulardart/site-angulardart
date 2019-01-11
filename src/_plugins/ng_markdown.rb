require_relative '../_shared/_plugins/markdown_with_code_excerpts'
require_relative 'ng_code_excerpt_framer'

module Jekyll
  module Converters

    # Kramdown plugin extension.
    #
    # Converts markdown code blocks preceded by a processing instruction (PI) of the form
    # <?code-excerpt?> into:
    #
    # - <code-example> elements suitable for use in Angular docs.
    # - diff2html elements
    #
    class NgMarkdown < Converter
      priority :high

      include MarkdownWithCodeExcerptsConverterMixin

      def initialize(config = {})
        super(config)
        @cec = MarkdownWithCodeExcerpts.new(config, DartSite::NgCodeExcerptFramer.new)
      end

      def convert(content)
        # Unescape {!{ ... }!} back to Angular {{ }}
        content.gsub!(/{!{/, '{{') # &#123;&#123;
        content.gsub!(/}!}/, '}}') # &#125;&#125;

        @cec.convert(content)
      end
    end
  end
end
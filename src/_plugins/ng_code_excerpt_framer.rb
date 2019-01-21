module DartSite

  # Takes the given code excerpt (with the given attributes) and creates
  # some framing HTML: e.g., a div with possible excerpt title in a header.
  class NgCodeExcerptFramer
    def frame_code(title, classes, attrs, escaped_code, indent)
      _unindented_template(title, classes, attrs, escaped_code)
    end

    private
    # @param [String] _div_classes, in the form "foo bar"
    # @param [Hash] attrs: attributes as attribute-name/value pairs.
    def _unindented_template(title, _div_classes, attrs, escaped_code)
      div_classes = ['code-example']
      div_classes << _div_classes if _div_classes

      pre_classes = attrs[:class] || []
      pre_classes.unshift("lang-#{attrs[:lang]}") if attrs[:lang]
      pre_classes.unshift('prettyprint')

      # <code-example data-webdev-raw #{attr_str attrs}>#{
      # escaped_code
      # }</code-example>

      <<~TEMPLATE.gsub(/!n\s*/,'').sub(/\bescaped_code\b/,escaped_code)
        <div class="#{div_classes * ' '}">
        #{title ? "<header><h4>#{title}</h4></header>" : '!n'}
        <copy-container>!n
          <pre class="#{pre_classes * ' '}">!n
            <code ng-non-bindable>escaped_code</code>!n
          </pre>!n
        </copy-container>
        </div>
      TEMPLATE
    end
  end
end

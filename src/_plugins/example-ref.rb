# Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
# for details. All rights reserved. Use of this source code is governed by a
# BSD-style license that can be found in the LICENSE file.

module ExampleRefTag

  # Renders a link to the named hosted example app. When the optional name
  # isn't provided, it is determined from the page URL.
  #
  # Usage:
  #   {% example_ref [example-name] %}optional link text{% endexample_ref %}
  #
  class Tag < Liquid::Block

    def initialize(tag_name, name, tokens)
      super
      @@config = Jekyll.configuration({}) unless defined? @@config
      @name = name.strip
    end

    def render(context)
      target_blank_attr = %w[target="_blank" rel="noopener"]
      no_external_attr = ['class="no-automatic-external"'] + target_blank_attr

      page_url = context.environments.first['page']['url']
      name = @name.empty? ? get_example_name(page_url) : @name

      link_text = super.strip
      text = link_text.empty? ? 'live example' : link_text

      href = "/examples/#{name}/"
      result = a(href, no_external_attr, text)

      src_text = 'view source'
      src_href = "#{@@config['ghNgEx']}/#{name}/tree/#{@@config['branch']}"
      result = span([],
                    "#{result} " + span(['class="text-nowrap"'],
                                        "(#{a(src_href, target_blank_attr, src_text)})"))
    end

    # Render even if the element is empty
    def blank?
      false
    end

    def get_example_name(page_path)
      # page_path is, e.g., /angular/guide/architecture
      name = nil
      matches = /.*\/([\w\-]+)(\.html)?/.match(page_path)
      if matches
        name = matches[1]
        matches = name.match(/(toh-)pt(\d+)/)
        name = matches[1] + matches[2] if matches
      end
      name
    end

    # HTML element
    def html(tag, attr, text)
      tag_and_attr = [tag]
      tag_and_attr.concat(attr)
      "<#{tag_and_attr.join(' ')}>#{text}</#{tag}>"
    end

    def a(href, attr, text)
      href = href.nil? ? [] : ["href=\"#{href}\""]
      html('a', href + attr, text)
    end

    def span(attr, text)
      html('span', attr, text)
    end

  end
end

Liquid::Template.register_tag('example_ref', ExampleRefTag::Tag)

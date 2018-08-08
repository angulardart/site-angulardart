# Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
# for details. All rights reserved. Use of this source code is governed by a
# BSD-style license that can be found in the LICENSE file.

require 'liquid/tag/parser' # https://github.com/envygeeks/liquid-tag-parser

module Jekyll
  # Renders a link to the named hosted example app. When the optional name
  # isn't provided, it is determined from the page URL.
  #
  # Usage:
  #   {% example_ref [example-name]
  #                  [text='live example']
  #                  [src-text='view source'] %}
  #
  class ExampleRefTag < Liquid::Tag
    def initialize(tag_name, args, tokens)
      super
      @@config = Jekyll.configuration({}) unless defined? @@config
      @args = Liquid::Tag::Parser.new(args).args
      @name = @args[:argv1] || ''
      @live_example_link_text = @args[:text] || 'live example'
      @view_source_link_text = @args[:'src-text'] || 'view source'
    end

    def render(context)
      target_blank_attr = %w[target="_blank" rel="noopener"]
      no_external_attr = ['class="no-automatic-external"'] + target_blank_attr

      page_url = context.environments.first['page']['url']
      name = @name.empty? ? get_example_name(page_url) : @name

      example_link = a(href: "/examples/#{name}",
                       attr: no_external_attr,
                       text: @live_example_link_text)

      src_href = "#{@@config['ghNgEx']}/#{name}/tree/#{@@config['branch']}"
      src_anchor = a(href: src_href, attr: target_blank_attr, text: @view_source_link_text)
      src_elt = span(src_anchor, attr: 'class="text-nowrap"')
      span("#{example_link} (#{src_elt})")
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

    def a(href: nil, attr: [], text: '')
      attr.unshift("href=\"#{href}\"") if href
      html('a', attr, text)
    end

    def span(text, attr: [])
      html('span', attr, text)
    end

    def html(tag, attr_or_array, text)
      tag_and_attr = [tag, attr_or_array]
                     .flatten.reject { |s| s.nil? || s.empty? }
      "<#{tag_and_attr.join(' ')}>#{text}</#{tag}>"
    end
  end
end

Liquid::Template.register_tag('example_ref', Jekyll::ExampleRefTag)

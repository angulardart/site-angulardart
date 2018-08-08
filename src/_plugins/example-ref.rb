# Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
# for details. All rights reserved. Use of this source code is governed by a
# BSD-style license that can be found in the LICENSE file.

require 'liquid/tag/parser' # https://github.com/envygeeks/liquid-tag-parser

module Jekyll
  # Renders a link to the named hosted example app. When the optional name
  # isn't provided, the page name (last part of the `page.url`) is used.
  #
  # Usage:
  #   {% example_ref [example-name]
  #                  [repo='example-repo-name']
  #                  [text='live example']
  #                  [src-text='view source'] %}
  #
  # Usually the example sources repo name coincides with the example name.
  # When it doesn't, supply a `repo` name -- for example, when the repo contains
  # multiple examples (like the ACX lottery).
  #
  class ExampleRefTag < Liquid::Tag
    def initialize(tag_name, args, tokens)
      super
      @@config = Jekyll.configuration({}) unless defined? @@config
      @args = Liquid::Tag::Parser.new(args).args
    end

    def render(context)
      target_blank_attr = %w[target="_blank" rel="noopener"]
      no_external_attr = ['class="no-automatic-external"'] + target_blank_attr

      name = @args[:argv1] || get_example_name(context)
      repo = @args[:repo]
      example_link = a(href: path_join_not_nil(['/examples', repo, name]),
                       attr: no_external_attr,
                       text: @args[:text] || 'live example')

      path = [@@config['ghNgEx'], repo || name, 'tree', @@config['branch']]
      path << name if repo
      src_anchor = a(href: path.join('/'),
                     attr: target_blank_attr,
                     text: @args[:'src-text'] || 'view source')
      src_elt = span(src_anchor, attr: 'class="text-nowrap"')
      span("#{example_link} (#{src_elt})")
    end

    # Render even if the element is empty
    def blank?
      false
    end

    def get_example_name(context)
      # page_url is, e.g., /angular/guide/architecture
      page_url = context.environments.first['page']['url']
      name = page_url.split('/').last
      if matches = name.match(/^(toh-)pt(\d+)/)
        name = matches[1] + matches[2]
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

    def path_join_not_nil(path_parts)
      path_parts.reject{|p| p.nil?}.join('/')
    end
  end
end

Liquid::Template.register_tag('example_ref', Jekyll::ExampleRefTag)

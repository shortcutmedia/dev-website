require 'uri'
require 'redcarpet'
require 'rouge'
require 'rouge/plugins/redcarpet'


module ApplicationHelper
  # create a custom renderer that allows highlighting of code blocks
  # class HTMLwithPygments < Redcarpet::Render::HTML
  #   def block_code(code, language)
  #     Pygments.highlight(code, lexer: language)
  #   end
  # end
  #
  # class HTML < Redcarpet::Render::HTML
  #   include Rouge::Plugins::Redcarpet # yep, that's it.
  # end
  #
  # class RenderWithoutCode < Redcarpet::Render::HTML
  #   def block_code(code, language)
  #     nil
  #   end
  # end
  
  class HTML < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet
    def rouge_formatter(opts={})
      opts ={
      }
      Rouge::Formatters::HTML.new(opts)
    end
  end

  def svg_image_tag(src, opts={})
    src = URI.parse(src)
    logger.debug "URI.parse: #{src}"

    src = URI.parse(asset_path src) unless src.host # prepand /images/ if relative src

    if src.fragment
      # use 'use'-tag to link to svg
      opts = opts.merge({class: src.fragment}) # defaults for opts
      opts = opts.merge("xmlns:xlink" => 'http://www.w3.org/1999/xlink')
      #concat_content(
        content_tag(:svg, opts) do
          content_tag :use, nil, {"xlink:href" => src }
        end
      #)
    else
    end
  end
  
  def markdown(text)
    render_options = {
      filter_html:     true,
      hard_wrap:       true, 
      link_attributes: { rel: 'nofollow' }
    }
    renderer = HTML.new(render_options)

    extensions = {
      autolink:           true,
      fenced_code_blocks: true,
      lax_spacing:        true,
      no_intra_emphasis:  true,
      strikethrough:      true,
      superscript:        true
    }
    Redcarpet::Markdown.new(renderer, extensions).render(text).html_safe
  end
end

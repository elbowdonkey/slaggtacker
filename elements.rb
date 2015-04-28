require "httparty"
require "nokogiri"
require "cgi"
require "pry"

class Elements
  include HTTParty

  attr_accessor :rerendered_html, :parsed_html

  def initialize(url, options = {})
    @css_class = options[:css_class] || "st-highlight"
    @wrapper_tag = options[:wrapper_tag] || "span"
    @highlight_tag = options[:highlight_tag] || "div"

    @parsed_html = Nokogiri::HTML(self.class.get(url))
  end

  ##
  # Returns a Hash of counts grouped by HTML tag
  #
  # ex:
  # {"html" => 1, "div" => 12}

  def stats
    @stats ||= Hash.new(0)
    @parsed_html.traverse { |e| update_counts_for e }
    @stats
  end

  ##
  # Returns an Array of key value pairs sorted by tag name
  #
  # ex:
  # [["div", 12],["html", 1]]

  def sorted_stats
    stats.zip.sort.map{ |pair| pair[0] }
  end

  ##
  # Wraps elements that match the supplied node_name with temporary markers
  # that will be replaced with real, non-html-encoded tags upon rendering
  # and then returns an HTML escaped string, leaving highlight markup un-escaped

  def add_highlights
    nodes = @parsed_html.css @highlight_tag
    nodes.wrap("<#{@wrapper_tag} class=\"#{@css_class}\"></#{@wrapper_tag}>")
    @rerendered_html = @parsed_html.to_html

    open_guts = "#{@wrapper_tag} class=\"#{@css_class}\""
    close_guts = "/#{@wrapper_tag}"

    squared_open = "[#{open_guts}]"
    squared_close = "[#{close_guts}]"

    arrowed_open = "<#{open_guts}>"
    arrowed_close = "<#{close_guts}>"

    # protect highlight elements from the voracious HTML escaping
    @rerendered_html.gsub!(arrowed_open,squared_open)
    @rerendered_html.gsub!(arrowed_close,squared_close)

    @rerendered_html = CGI.escapeHTML(@rerendered_html)

    # restore highlight elements so we can use them when rendering the page
    @rerendered_html.gsub!(CGI.escapeHTML(squared_open),arrowed_open)
    @rerendered_html.gsub!(CGI.escapeHTML(squared_close),arrowed_close)
  end

  private

  def update_counts_for element
    # only allow html tags to be highlighted
    @stats[element.node_name] += 1 if element.type == 1
  end
end
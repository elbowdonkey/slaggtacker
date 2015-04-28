require File.expand_path("elements.rb")
require File.expand_path("spec/spec_helper.rb")

RSpec.describe Elements, :vcr do

  let(:test_url) { "http://localhost:5000/test" }
  let(:options) {{
    css_class: "st-highlight",
    wrapper_tag: "span",
    highlight_tag: "cite"
  }}
  let(:elements) { Elements.new(test_url, options) }

  describe '#new' do
    it 'returns an Elements object' do
      expect(elements.class).to eq(Elements)
    end

    it 'can handle a lack of http://' do
      expect { Elements.new("collusioni.st", options) }.to_not raise_error
    end

    it 'raises an exception when given a terrible URL' do
      expect { Elements.new("timmy", options) }.to raise_error
    end
  end

  describe '#add_highlights and #rerendered_html' do
    it 'escapes all HTML while wrapping highlighted elements with unescaped HTML used for rendering highlight' do
      expected_results = ""
      expected_results += "&lt;!DOCTYPE html&gt;\n"
      expected_results += "&lt;html&gt;\n"
      expected_results += "  &lt;body&gt;\n"
      expected_results += "    &lt;p&gt;stuff to be <span class=\"st-highlight\">&lt;cite&gt;highlighted&lt;/cite&gt;</span>&lt;/p&gt;\n"
      expected_results += "  &lt;/body&gt;\n"
      expected_results += "&lt;/html&gt;\n"

      expect(elements.rerendered_html).to eq expected_results
    end
  end

  describe '#stats' do
    it 'returns a hash with tag counts' do
      expect(elements.stats).to eq( {"body" => 1, "html" => 1, "p" => 1, "cite" => 1} )
    end
  end

  describe '#sorted_stats' do
    it 'returns an array of counts sorted by tag name' do
      expect(elements.sorted_stats).to eq( [["body", 1], ["cite", 1], ["html", 1], ["p", 1]] )
    end
  end
end

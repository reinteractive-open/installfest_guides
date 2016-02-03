require 'middleman-core/util'

describe "Middleman::Util#binary?" do
  %w(plain.txt unicode.txt unicode).each do |file|
    it "recognizes #{file} as not binary" do
      expect(Middleman::Util.binary?(File.join(File.dirname(__FILE__), "binary_spec/#{file}"))).to be false
    end
  end

  %w(middleman.png middleman stars.svgz).each do |file|
    it "recognizes #{file} as binary" do
      expect(Middleman::Util.binary?(File.join(File.dirname(__FILE__), "binary_spec/#{file}"))).to be true
    end
  end
end

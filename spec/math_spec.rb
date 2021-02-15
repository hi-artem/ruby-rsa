$LOAD_PATH.unshift(File.expand_path('../lib', File.dirname(__FILE__)))

require 'ruby_rsa'

RSpec.describe RSA::Math do
  describe "#even_binary?" do
    it "identifies even binary string" do
      result = RSA::Math.even_binary?("11111111")
      expect(result).to be false
    end
  end
end

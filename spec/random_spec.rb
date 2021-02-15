$LOAD_PATH.unshift(File.expand_path('../lib', File.dirname(__FILE__)))

require 'ruby_rsa'
# use openssl to test primes
require 'openssl'

RSpec.describe RSA::Random do
  describe "#random_bits" do
    it "generates random bits of correct size" do
      rb1 = RSA::Random.random_bits(1024)
      rb2 = RSA::Random.random_bits(1024)
      expect(rb1).not_to eq(rb2)
    end
  end

  describe "#odd_random_number" do
    it "generates odd random number" do
      num1 = RSA::Random.odd_random_number(256).to_i(2)
      result1 = num1.odd?
      expect(result1).to be true 
    end
  end

  describe "#odd_random_prime" do
    it "generates odd random prime number" do
      num1 = RSA::Random.odd_random_prime(1024)
      bnum1 =  OpenSSL::BN.new(num1)
      result1 = bnum1.odd?
      expect(result1).to be true 
    end
  end
end

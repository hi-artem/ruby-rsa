$LOAD_PATH.unshift(File.expand_path('../lib', File.dirname(__FILE__)))

require 'ruby_rsa'
# use openssl to test primes
require 'openssl'

BITS_SIZE=256

RSpec.describe RSA::Random do
  describe "#random_bits" do
    it "generates random bits of correct size" do
      rb1 = RSA::Random.random_bits(BITS_SIZE)
      rb2 = RSA::Random.random_bits(BITS_SIZE)
      expect(rb1).not_to eq(rb2)
      expect(rb1.length).to eq(BITS_SIZE/8)
    end
  end

  describe "#random_odd" do
    it "generates odd random number" do
      num1 = RSA::Random.random_odd(BITS_SIZE).to_i(2)
      result1 = num1.odd?
      expect(result1).to be true 
    end
  end

  describe "#random_prime" do
    it "generates odd random prime number" do
      num1 = RSA::Random.random_prime(BITS_SIZE)
      bnum1 =  OpenSSL::BN.new(num1)
      result1 = bnum1.odd?
      expect(result1).to be true 
    end
  end
end

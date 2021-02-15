# frozen_string_literal: true

module RSA
  module Random
    def self.random_bits(size)
      # this should be restructured to multiple calls
      # since urandom can only generate 256bit a a time securely
      ::Random.urandom(size / 8) 
    end

    def self.odd_random_number(size)
      b_string = random_bits(size).unpack('B*')[0]
      return b_string unless RSA::Math.even_binary?(b_string)
      odd_random_number(size) 
    end

    def self.odd_random_prime(size)
      loop do
        b_string = odd_random_number(size)
        if RSA::Math.prime?(b_string.to_i(2))
          return b_string
        end
      end
    end
  end
end

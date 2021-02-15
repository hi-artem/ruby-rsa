# frozen_string_literal: true

module RSA
  module Math
    def self.even_binary?(b_string)
      b_string[-1] == "0" ? true : false
    end
    
    def self.prime?(decimal_int)
      queue = Queue.new
      threads = []

      (0..10).each do |t|
        threads << Thread.new { queue.push(miller_rabin(decimal_int)) }
      end

      result = queue.pop
      threads.each(&:kill).each(&:join)
      result
    end

    private
      def self.likely_prime?(a, n)
        d = n - 1
        s = 0
        while d % 2 == 0 do
          d >>= 1
          s += 1
        end

        b = 1
        while d > 0
          u = d % 2
          t = d / 2
          b = (b * a) % n if u == 1
          a = a**2 % n
          d = t
        end

        if b == 1
          true
        else
          s.times do |i|
            return true if b == n - 1
            b = (b * b) % n
          end
          (b == n - 1)
        end
      end

      def self.miller_rabin(n)
        if n.abs < 2
          false
        else
          likely_prime = true
          # openssl does 64 rounds for 1024bits and 128 rounds for 2048bits
          # read more: https://www.openssl.org/docs/manmaster/man3/BN_check_prime.html
          27.times do |i|
            begin
              a = rand(n)
            end while a == 0
            likely_prime = likely_prime?(a, n)
            break unless likely_prime
          end
          likely_prime
        end
      end
  end
end

# frozen_string_literal: true

module RSA
  module Math
    def self.modpow(base, exponent, modulus)
      result = 1
      while exponent > 0
        result   = (base * result) % modulus unless (exponent & 1).zero?
        base     = (base * base)   % modulus
        exponent >>= 1
      end
      result
    end

    def self.gcd(a, b)
      larger = a > b ? a : b
      smaller = a > b ? b : a
      if smaller > 0
        gcd(smaller, larger % smaller)
      else
        larger
      end
    end

    # the extended euclidean algorithm
    def self.inverse(modulus, num)
      last_remainder = modulus.abs
      remainder = num.abs
      x = 0
      last_x = 1
      y = 1
      last_y = 0
      while remainder != 0
        quotient = last_remainder / remainder
        temp_remainder = remainder
        remainder = last_remainder % remainder
        last_remainder = temp_remainder
        temp_x = x
        x = last_x - quotient*x
        last_x = temp_x
        temp_y = y
        y = last_y - quotient*y
        last_y = temp_y
      end
      raise if last_remainder != 1
      (last_x * (modulus < 0 ? -1 : 1)) % num
    end

    def self.even_binary?(b_string)
      b_string[-1] == "0" ? true : false
    end
    
    def self.prime?(decimal_int)
      queue = Queue.new
      threads = []

      (0..5).each do |t|
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
          q = Queue.new
          t = []

          likely_prime = true
          # openssl does 64 rounds for 1024bits and 128 rounds for 2048bits
          # read more: https://www.openssl.org/docs/manmaster/man3/BN_check_prime.html
          64.times do |i|
            begin
              a = rand(n)
            end while a == 0
            t << Thread.new { q.push(likely_prime?(a,n)) }
            likely_prime = q.pop
            break unless likely_prime
          end
          t.each(&:kill).each(&:join)
          likely_prime
        end
      end
  end
end

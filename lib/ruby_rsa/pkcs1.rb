# frozen_string_literal: true
require 'rasn1'

module RSA
  module PKCS 
    class RSAPrivateKey < RASN1::Model
      sequence :record,
               content: [integer(:version),
                         integer(:modulus),
                         integer(:publicExponent),
                         integer(:privateExponent),
                         integer(:prime1),
                         integer(:prime2),
                         integer(:exponent1),
                         integer(:exponent2),
                         integer(:coefficient)]
    end

    class RSAPublicKey < RASN1::Model
      sequence :record,
               content: [integer(:modulus),
                         integer(:publicExponent)]
    end

    def self.initialize_private(key)
      RSAPrivateKey.new(
        version: 0,
        modulus: key.n,
        publicExponent: key.e,
        privateExponent: key.d,
        prime1: key.p,
        prime2: key.q,
        exponent1: key.exp1,
        exponent2: key.exp2,
        coefficient: key.coef)
    end

    def self.to_der_private(key)
      key_asn1 = initialize_private(key)
      key_asn1.to_der
    end

    def self.write_private(filename, key)
      der = to_der_private(key)
      File.open(filename, 'wb') {|file| file.write(der) }
    end

    def self.initialize_public(key)
      RSAPrivateKey.new(
        modulus: key.n,
        publicExponent: key.e)
    end

    def self.to_der_public(key)
      key_asn1 = initialize_public(key)
      key_asn1.to_der
    end

    def self.write_public(filename, key)
      File.open(filename, 'wb') {|file| file.write(der) }
    end

    def self.i2osp(x, len = nil)
      raise ArgumentError, "integer too large" if len && x >= 256**len

      StringIO.open do |buffer|
        while x > 0
          b = (x & 0xFF).chr
          x >>= 8
          buffer << b
        end
        s = buffer.string
        s.force_encoding(Encoding::BINARY) if s.respond_to?(:force_encoding)
        s.reverse!
        s = len ? s.rjust(len, "\0") : s
      end
    end

    def self.os2ip(x)
      x.bytes.inject(0) { |n, b| (n << 8) + b }
    end

    def self.rsaep(key, message)
      RSA::Math.modpow(message, key.e, key.n)
    end

    def self.rsadp(key, ciphertext)
      RSA::Math.modpow(ciphertext, key.d, key.n)
    end
  end
end

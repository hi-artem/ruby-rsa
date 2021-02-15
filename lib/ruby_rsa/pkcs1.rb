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

    def self.write_private_key(filename, key)
      key = RSAPrivateKey.new(
        version: 0,
        modulus: key.n,
        publicExponent: key.e,
        privateExponent: key.d,
        prime1: key.p,
        prime2: key.q,
        exponent1: key.exp1,
        exponent2: key.exp2,
        coefficient: key.coef)

      der = key.to_der

      File.open(filename, 'wb') {|file| file.write(der) }
    end
  end
end

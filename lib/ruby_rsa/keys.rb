# frozen_string_literal: true

module RSA
  class Key
    def initialize
      raise 'subclass is expected to implement initialize'
    end

    def export_to_file 
      raise 'subclass is expected to implement export_to_file'
    end

    def import_from_file 
      raise 'subclas is expected to implement import_from_file'
    end

    def encrypt(plaintext)
      case plaintext
        when Integer      then encrypt_integer(plaintext)
        when String       then RSA::PKCS.i2osp(encrypt_integer(RSA::PKCS.os2ip(plaintext)))
        when StringIO, IO then RSA::PKCS.i2osp(encrypt_integer(RSA::PKCS.os2ip(plaintext.read)))
        else raise ArgumentError, plaintext.inspect
      end
    end
    
    private
      def encrypt_integer(plaintext)
        RSA::PKCS.rsaep(self, plaintext)
      end
  end

  class PrivateKey < Key
    attr_reader :n, :e, :d, :p, :q, :exp1, :exp2, :coef

    def initialize(size = 1024)
      @e = 65537
      begin
        @p = RSA::Random.random_prime(size).to_i(2)
        @q = RSA::Random.random_prime(size).to_i(2)
        @n = @p*@q
        phi_n = (@p-1)*(@q-1)
        # until Phi(n) is relatively prime to 65537, keep calculating new p and q values
      end while RSA::Math.gcd(@e, phi_n) != 1
      @d = RSA::Math.inverse(@e, phi_n)
      @exp1 = @d % ( @p - 1)
      @exp2 = @d % ( @q - 1)
      @coef = RSA::Math.inverse(@q, @p)
    end

    def export_to_file(filename, fomat = "DER")
      RSA::PKCS.write_private(filename, self)
    end

    def import_from_file 
      raise 'import_from_file method is currently not implemented'
    end

    def decrypt(ciphertext)
      case ciphertext
        when Integer      then decrypt_integer(ciphertext)
        when String       then RSA::PKCS.i2osp(decrypt_integer(RSA::PKCS.os2ip(ciphertext)))
        when StringIO, IO then RSA::PKCS.i2osp(decrypt_integer(RSA::PKCS.os2ip(ciphertext.read)))
        else raise ArgumentError, ciphertext.inspect
      end
    end

    private
      def decrypt_integer(ciphertext)
        RSA::PKCS.rsadp(self, ciphertext)
      end
  end

  class PublicKey < Key
    attr_reader :n, :e
    def initialize(private_key)
      @n = private_key.n
      @e = private_key.e
    end

    def export_to_file(filename, fomat = "DER")
      RSA::PKCS.write_public(filename, self)
    end

    def import_from_file 
      raise 'import_from_file method is currently not implemented'
    end
  end
end

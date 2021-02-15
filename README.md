# ruby_rsa

Attempt at pure-Ruby RSA implementation. This is a hobby project and doesn't 
provide any real cryptographic security.

The project is currently capable of generating RSA key pairs of various sizes,
export and import private keys in PKCS1 DER format, and encrypt and decrypt 
messages. 

## Implementation

The prime numbers are generated using urandom from Ruby's Random module, which
is system independent. The primes are tested using Miller-Rabin algorithm.

Keys are generated following PKCS1 scheme, and could be exported as DER, and
later imported by other systems, like OpenSSL.

The messages and encrypted and decrypted following PKCS1 specification.

## Credits

This project is using/inspired by the following open-source projects:

- [python-rsa](https://github.com/sybrenstuvel/python-rsa) - Inspiration and some design aspects
- [rasn1](https://github.com/sdaubert/rasn1) - ASN.1 encoding/decoding
- [rsa.rb](https://github.com/dryruby/rsa.rb) - PKCS data conversion and encryption/decryption procedures
- [rsa](https://github.com/mcrossen/rsa) - GCD and inverse algorithms implementation
- [prime_miller_rabin](https://github.com/ChapterHouse/prime_miller_rabin) - Miller-Rabin implementation
- [openssl](https://github.com/ruby/openssl) - Test generated prime numbers, keys and etc
- [boringssl](https://boringssl.googlesource.com/boringssl/) - Inspiration mostly

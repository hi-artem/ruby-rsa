$LOAD_PATH.unshift(File.expand_path('../lib', File.dirname(__FILE__)))

require 'ruby_rsa'

RSpec.describe RSA::PrivateKey do
  TEXT = "hello_world"
  LONG_TEXT = "sit amet risus nullam eget felis eget nunc lobortis mattis aliquam faucibus purus in massa tempor nec feugiat nisl pretium fusce id velit ut tortor pretium viverra suspendisse potenti nullam ac tortor vitae purus faucibus ornare suspendisse sed nisi lacus sed viverra tellus in hac habitasse platea dictumst vestibulum rhoncus est pellentesque elit ullamcorper dignissim cras tincidunt lobortis feugiat vivamus at augue eget arcu dictum varius duis at consectetur lorem donec massa sapien faucibus et molestie ac feugiat sed lectus vestibulum mattis ullamcorper velit sed ullamcorper morbi tincidunt ornare massa eget egestas purus viverra accumsan in nisl nisi scelerisque eu ultrices vitae auctor eu augue ut lectus arcu bibendum at varius vel pharetra vel turpis nunc eget lorem dolor sed viverra ipsum nunc aliquet bibendum enim facilisis gravida neque convallis a cras semper auctor neque vitae tempus quam pellentesque nec nam aliquam sem et tortor consequat id porta nibh venenatis cras sed felis eget velit aliquet sagittis id consectetur purus ut faucibus pulvinar elementum integer enim neque volutpat ac tincidunt vitae semper quis lectus nulla at volutpat diam ut venenatis tellus in metus vulputate eu scelerisque felis imperdiet proin fermentum leo vel orci porta non pulvinar neque laoreet suspendisse interdum"

  NUMBER = 42
  LONG_NUMBER = 2172438144153523191797514845768978840059951442289680164532864184685547922356009419851528349538943053468164575529347183447237985674877495511362755311398267998723416351132029448662599089344018433204601488464851975319163601622541575749878009783454111762347930734169776166129253952205717070005468540292031076882533069248113259799403917015155225098290079012953088751039882656122199466679489191370819252477

  describe "#initialize" do
    it "creates new private key with default size" do
      key = RSA::PrivateKey.new
      expect(key.n).to be_kind_of(Numeric)
      expect(key.e).to be_kind_of(Numeric)
      expect(key.d).to be_kind_of(Numeric)
      expect(key.p).to be_kind_of(Numeric)
      expect(key.q).to be_kind_of(Numeric)
      expect(key.exp1).to be_kind_of(Numeric)
      expect(key.exp2).to be_kind_of(Numeric)
      expect(key.coef).to be_kind_of(Numeric)
    end
    
    it "creates new private key with custom size" do
      key = RSA::PrivateKey.new(256)
      expect(key.n).to be_kind_of(Numeric)
      expect(key.e).to be_kind_of(Numeric)
      expect(key.d).to be_kind_of(Numeric)
      expect(key.p).to be_kind_of(Numeric)
      expect(key.q).to be_kind_of(Numeric)
      expect(key.exp1).to be_kind_of(Numeric)
      expect(key.exp2).to be_kind_of(Numeric)
      expect(key.coef).to be_kind_of(Numeric)
    end
    
    it "creates new public key from private key" do
      priv_key = RSA::PrivateKey.new(256)
      pub_key = RSA::PublicKey.new(priv_key)
      expect(pub_key.n).to be_kind_of(Numeric)
      expect(pub_key.e).to be_kind_of(Numeric)
    end

    it "encrypts and decrypts data with generated private key" do
      priv_key = RSA::PrivateKey.new(256)

      cipher = priv_key.encrypt(TEXT)
      message = priv_key.decrypt(cipher) 
      expect(message).to eq(message)
      
      cipher = priv_key.encrypt(LONG_TEXT)
      message = priv_key.decrypt(cipher) 
      expect(message).to eq(message)

      cipher = priv_key.encrypt(NUMBER)
      message = priv_key.decrypt(cipher) 
      expect(message).to eq(message)

      cipher = priv_key.encrypt(LONG_NUMBER)
      message = priv_key.decrypt(cipher) 
      expect(message).to eq(message)
    end

    it "encrypts data with generated public key and decrypts with private key" do
      priv_key = RSA::PrivateKey.new(256)
      pub_key = RSA::PublicKey.new(priv_key)

      cipher = pub_key.encrypt(TEXT)
      message = priv_key.decrypt(cipher) 
      expect(message).to eq(message)
      
      cipher = pub_key.encrypt(LONG_TEXT)
      message = priv_key.decrypt(cipher) 
      expect(message).to eq(message)

      cipher = pub_key.encrypt(NUMBER)
      message = priv_key.decrypt(cipher) 
      expect(message).to eq(message)

      cipher = pub_key.encrypt(LONG_NUMBER)
      message = priv_key.decrypt(cipher) 
      expect(message).to eq(message)
    end
  end
end

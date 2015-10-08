require 'json/jwt'

def test_private_key
  OpenSSL::PKey::RSA.new File.read(File.expand_path('../fixtures/test_rsa_key', __dir__))
end

def valid_token(payload = { 'bar' => 'baz' })
  @valid_token ||= begin
                     jwt = JSON::JWT.new(payload)
                     jws = jwt.sign(test_private_key, :RS256)
                     jwe = jws.encrypt(test_private_key, :'RSA-OAEP', :A256GCM)

                     jwe.to_s
                   end
end

def invalid_token
  @invalid_token ||= valid_token.tr('a', 'f')
end

require 'json/jwt'
require 'base64'

def test_private_key
  OpenSSL::PKey::RSA.new File.read(File.expand_path('../fixtures/test_rsa_key', __dir__))
end

def valid_jwe_token(payload = { 'bar' => 'baz' })
  @valid_token ||= begin
                     jwt = JSON::JWT.new(payload)
                     jws = jwt.sign(test_private_key, :RS256)
                     jwe = jws.encrypt(test_private_key, :'RSA-OAEP', :A256GCM)

                     jwe.to_s
                   end
end

def invalid_jwe_token
  @invalid_token ||= valid_jwe_token.tr('a', 'f')
end

def valid_b64_token(payload = 'hereisacoollittlestring')
  @valid_b64_token ||= Base64.encode64(payload).chomp
end

def invalid_b64_token
  @invalid_b64_token ||= valid_b64_token.tr('abcdefghijklmnop', '$o#m$k#i$g#e$c#a')
end

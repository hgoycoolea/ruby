require 'base64'
require 'openssl'
include OpenSSL

shared_secret = "Kah942*$7sdp0)"
plaintext= "10000GBP2007-10-20Internet Order 123454aD37dJATestMerchant2007-10-11T11:00:00Z"

# output should be x58ZcRVL1H6y+XSeBGrySJ9ACVo=
# make sure you "strip" the base64 encoded string as Ruby, similar to Python,
# will append a newline to the string

digest = OpenSSL::HMAC.digest(OpenSSL::Digest::SHA1.new, shared_secret, plaintext)
puts Base64.encode64(digest).strip

require 'cogitate'
Cogitate.configure do |config|
  config.tokenizer_password = Figaro.env.cogitate_services_tokenizer_private_password!
  config.tokenizer_encryption_type = Figaro.env.cogitate_services_tokenizer_encryption_type!
  config.tokenizer_issuer_claim = Figaro.env.cogitate_services_tokenizer_issuer_claim!
end

module Cogitate
  # Responsible for containing the configuration information for Cogitate
  class Configuration
    # If something is not properly configured
    class ConfigurationError < RuntimeError
      def initialize(method_name)
        super("Cogitate::Configuration##{method_name} has not been set")
      end
    end

    CONFIG_ATTRIBUTE_NAMES = [
      :remote_server_base_url,
      :tokenizer_password,
      :tokenizer_encryption_type,
      :tokenizer_issuer_claim
    ].freeze
    private_constant :CONFIG_ATTRIBUTE_NAMES

    def initialize(**keywords)
      CONFIG_ATTRIBUTE_NAMES.each do |name|
        send("#{name}=", keywords.fetch(name)) if keywords.key?(name)
      end
    end

    CONFIG_ATTRIBUTE_NAMES.each do |method_name|
      attr_writer method_name
      define_method(method_name) do
        instance_variable_get("@#{method_name}") || fail(ConfigurationError, method_name)
      end
    end

    # !@attribute [rw] remote_server_base_url
    #   @return [String] What is the URL of the Cogitate server you want to connect to?
    # !@attribute [rw] tokenizer_password
    #   What is the tokenizer password you are going to be using to:
    #   * create a token (i.e. a private RSA key)
    #   * decode a token (i.e. a public RSA key)
    #
    #   If you are implemnting a Cogitate client, you'll want to use the public key
    #   @return [String]
    #   @see Cogitate::Services::Tokenizer
    # !@attribute [rw] tokenizer_encryption_type
    #   What is the encryption type for the tokenizer. You will need to ensure that
    #   the Cogitate server and client are using the same encryption mechanism.
    #   @return [String]
    #   @example `configuration.tokenizer_encryption_type = 'RS256'`
    #   @see Cogitate::Services::Tokenizer
    # !@attribute [rw] tokenizer_issuer_claim
    #   As per JSON Web Token specification, what is the Issuer Claim
    #   the Cogitate server and client are using the same encryption mechanism.
    #   @return [String]
    #   @example `configuration.tokenizer_issuer_claim = 'https://library.nd.edu'`
    #   @see https://tools.ietf.org/html/rfc7519#section-4.1.1
    #   @see https://github.com/jwt/ruby-jwt#issuer-claim
  end
end

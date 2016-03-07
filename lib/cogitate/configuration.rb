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
      # !@attribute [rw] after_authentication_callback_url
      #   Where should the Cogitate server redirect to after a successful authentication?
      #   @note Cogitate::Client configuration (and not Cogitate::Server)
      :after_authentication_callback_url,
      # !@attribute [rw] remote_server_base_url
      # @note Cogitate::Client configuration
      #   @return [String] What is the URL of the Cogitate server you want to connect to?
      :remote_server_base_url,
      # !@attribute [rw] tokenizer_password
      #   What is the tokenizer password you are going to be using to:
      #   * create a token (i.e. a private RSA key)
      #   * decode a token (i.e. a public RSA key)
      #
      #   If you are implemnting a Cogitate client, you'll want to use the public key
      #   @return [String]
      #   @note Cogitate::Client and Cogitate::Server configuration
      #   @see Cogitate::Services::Tokenizer
      :tokenizer_password,
      # !@attribute [rw] tokenizer_encryption_type
      #   What is the encryption type for the tokenizer. You will need to ensure that
      #   the Cogitate server and client are using the same encryption mechanism.
      #   @return [String]
      #   @note Cogitate::Client and Cogitate::Server configuration
      #   @example `configuration.tokenizer_encryption_type = 'RS256'`
      #   @see Cogitate::Services::Tokenizer
      :tokenizer_encryption_type,
      # !@attribute [rw] tokenizer_issuer_claim
      #   As per JSON Web Token specification, what is the Issuer Claim
      #   the Cogitate server and client are using the same encryption mechanism.
      #
      #   @note Cogitate::Client and Cogitate::Server configuration
      #   @return [String]
      #   @example `configuration.tokenizer_issuer_claim = 'https://library.nd.edu'`
      #   @see https://tools.ietf.org/html/rfc7519#section-4.1.1
      #   @see https://github.com/jwt/ruby-jwt#issuer-claim
      :tokenizer_issuer_claim
    ].freeze

    def initialize(client_request_handler: default_client_request_handler, **keywords)
      CONFIG_ATTRIBUTE_NAMES.each do |name|
        send("#{name}=", keywords.fetch(name)) if keywords.key?(name)
      end
      self.client_request_handler = client_request_handler
    end

    CONFIG_ATTRIBUTE_NAMES.each do |method_name|
      attr_writer method_name
      define_method(method_name) do
        instance_variable_get("@#{method_name}") || raise(ConfigurationError, method_name)
      end
    end

    # What is the authentication URL of the client's configured Cogitate server
    # @note Cogitate::Client configuration (and not Cogitate::Server)
    # @return String
    def url_for_authentication
      query_params = "?after_authentication_callback_url=#{CGI.escape(after_authentication_callback_url)}"
      File.join(remote_server_base_url, '/authenticate') << query_params
    end

    # What is the URL for claiming a ticket
    # @note Cogitate::Client configuration (and not Cogitate::Server)
    # @return String
    def url_for_claiming_a_ticket
      File.join(remote_server_base_url, '/claim')
    end

    # What is the URL for retrieving the agents based on the given identifiers
    # @note Cogitate::Client configuration (and not Cogitate::Server)
    # @param urlsafe_base64_encoded_identifiers [String]
    # @return String
    def url_for_retrieving_agents_for(urlsafe_base64_encoded_identifiers:)
      File.join(remote_server_base_url, '/api/agents', urlsafe_base64_encoded_identifiers)
    end

    # What will be negotiating the remote request to the Cogitate::Server
    #
    # @return [#call(url:)]
    # @see #default_client_request_handler for interface
    attr_reader :client_request_handler

    private

    attr_writer :client_request_handler

    def default_client_request_handler
      lambda do |url:|
        require 'rest-client' unless defined?(RestClient)
        RestClient.get(url).body
      end
    end
  end
end

module Cogitate
  # Responsible for containing the configuration information for Cogitate
  class Configuration
    # :nodoc:
    class ConfigurationError < RuntimeError
      def initialize(method_name)
        super("Cogitate::Configuration##{method_name} has not been set")
      end
    end

    CONFIG_ATTRIBUTE_NAMES = [:tokenizer_password, :tokenizer_encryption_type, :tokenizer_issuer_claim].freeze
    private_constant :CONFIG_ATTRIBUTE_NAMES

    def initialize(**keywords)
      CONFIG_ATTRIBUTE_NAMES.each do |name|
        send("#{name}=", keywords.fetch(name)) if keywords.key?(name)
      end
    end

    attr_writer(*CONFIG_ATTRIBUTE_NAMES)

    def tokenizer_password
      @tokenizer_password || fail(ConfigurationError, :tokenizer_password)
    end

    def tokenizer_encryption_type
      @tokenizer_encryption_type || fail(ConfigurationError, :tokenizer_password)
    end

    def tokenizer_issuer_claim
      @tokenizer_issuer_claim || fail(ConfigurationError, :tokenizer_password)
    end
  end
end

require 'base64'

module Cogitate
  # Responsible for collecting the various client related behaviors.
  module Client
    # @api public
    def self.encoded_identifier_for(strategy:, identifying_value:)
      Base64.urlsafe_encode64("#{strategy.to_s.downcase}\t#{identifying_value}")
    end
  end
end

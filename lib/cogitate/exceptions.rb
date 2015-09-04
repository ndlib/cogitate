module Cogitate
  # When the thing we are trying to decode is improperly encoded, this exception is to provide clarity
  class InvalidIdentifierEncoding < ArgumentError
    def initialize(encoded_string:)
      super("Unable to decode #{encoded_string}; Expected it to be URL-safe Base64 encoded (use Base64.urlsafe_encode64)")
    end
  end

  # When the thing we have decoded is not properly formated, this exception is to provide clarity
  class InvalidIdentifierFormat < RuntimeError
    EXPECTED_FORMAT = "strategy\tvalue\nstrategy\tvalue".freeze
    def initialize(decoded_string:)
      super("Expected #{decoded_string.inspect} to be of the format #{EXPECTED_FORMAT.inspect}")
    end
  end

  # When the thing we have decoded is not properly formated, this exception is to provide clarity
  class InvalidMembershipVisitationKeys < RuntimeError
    def initialize(identifier:, visitation_type:)
      super("Unable to find MembershipVisitationStrategy for visitation_type: #{visitation_type.inspect}, identifier: #{identifier.inspect}")
    end
  end
end

require 'cogitate/interfaces'
require 'active_support/core_ext/class/attribute'

# An identifier that has been verified, and may be decorated with additional information
class Identifier
  # Identifier's that have been verified can be used for authorization.
  module Verified
    # Responsible for building a verified identifier
    #
    # @api private This is private for now; I'm seeing how it holds out in usage.
    # @return Class
    def self.build_named_strategy(*given_attribute_keys)
      Class.new do
        class_attribute :attribute_keys
        self.attribute_keys = given_attribute_keys.freeze

        define_method :initialize do |identifier:, attributes:|
          self.identifier = identifier
          attributes.each_pair do |key, value|
            next unless attribute_keys.include?(key.to_s)
            send("#{key}=", value) if respond_to?("#{key}=", true)
          end
          self
        end

        define_method :as_json do |*|
          attribute_keys.each_with_object({}) do |key, mem|
            mem[key] = send(key)
            mem
          end
        end

        define_method(:verified?) { true }
        define_method(:strategy) { "verified/#{identifier.strategy}" }

        attr_reader(*attribute_keys)

        extend Forwardable
        include Comparable
        # TODO: Consider if :<=> should be a mixin module for comparison? In delegating down to the identifier, I'm ignoring that
        #   I could be comparing a verified identifier to an unverified identifier and say they are the same.
        def_delegators :identifier, :identifying_value, :<=>, :base_identifying_value, :base_strategy

        private

        attr_accessor :identifier

        attr_writer(*attribute_keys)
      end
    end
  end
end

require 'cogitate/interfaces'
require 'active_support/core_ext/class/attribute'
require 'cogitate/models/identifier'

module Cogitate
  module Models
    # An identifier that has been verified, and may be decorated with additional information
    class Identifier
      # Identifier's that have been verified can be used for authorization.
      module Verified
        # Responsible for building a verified identifier
        #
        # @api private This is private for now; I'm seeing how it holds out in usage.
        # @return Class
        def self.build_named_strategy(*given_attribute_keys, &block)
          Class.new do
            class_attribute :attribute_keys, instance_predicate: false, instance_writer: false
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
              attribute_keys.each_with_object('identifying_value' => identifying_value, 'strategy' => strategy) do |key, mem|
                mem[key] = send(key)
                mem
              end
            end

            define_method(:verified?) { true }

            attr_reader(*attribute_keys)

            extend Forwardable
            include Comparable
            # TODO: Consider if :<=> should be a mixin module for comparison? In delegating down to the identifier, I'm ignoring that
            #   I could be comparing a verified identifier to an unverified identifier and say they are the same.
            def_delegators :identifier, :identifying_value, :<=>, :encoded_id, :strategy

            private

            attr_accessor :identifier

            attr_writer(*attribute_keys)

            public

            module_exec(&block) if block_given?
          end
        end
      end
    end
  end
end

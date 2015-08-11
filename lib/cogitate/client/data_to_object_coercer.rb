require 'cogitate/client/agent_builder'

module Cogitate
  module Client
    # Responsible for coercing a JSON hash into a Cogitate::Client object
    #
    # @see Cogitate::Client::DataToObjectCoercer.call
    module DataToObjectCoercer
      module_function

      # @api public
      #
      # Responsible for coercing a JSON hash into a Cogitate::Client object
      #
      # @param data [Hash] with string keys
      # @param type_to_builder_map [Hash] a lookup table of key to constant
      # @return the result of building the object as per the :type_to_builder_map
      # @raise KeyError if `data` does not have 'type' key or if `type_to_builder_map` does not have `data['type']` key
      def call(data, type_to_builder_map: default_type_to_builder_map)
        type = data.fetch('type')
        builder = type_to_builder_map.fetch(type.to_s)
        builder.call(data)
      end

      TYPE_TO_BUILDER_MAP = {
        'agents' => AgentBuilder,
        'agent' => AgentBuilder
      }.freeze
      private_constant :TYPE_TO_BUILDER_MAP

      # @api private
      def default_type_to_builder_map
        TYPE_TO_BUILDER_MAP
      end
      private_class_method :default_type_to_builder_map
    end
  end
end

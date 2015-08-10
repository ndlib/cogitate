require 'cogitate/client/agent_builder'

module Cogitate
  module Client
    # Responsible for coercing a JSON hash into a Cogitate::Client object
    module DataToObjectCoercer
      module_function

      TYPE_TO_BUILDER_MAP = {
        'agents' => AgentBuilder,
        'agent' => AgentBuilder
      }.freeze
      private_constant :TYPE_TO_BUILDER_MAP

      # @api public
      def call(data, type_to_builder_map: default_type_to_builder_map)
        type = data.fetch('type') { data.fetch(:type) }
        builder = type_to_builder_map.fetch(type.to_s)
        builder.build(data)
      end

      # @api private
      def default_type_to_builder_map
        TYPE_TO_BUILDER_MAP
      end
      private_class_method :default_type_to_builder_map
    end
  end
end

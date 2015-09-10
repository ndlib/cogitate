module Cogitate
  module Client
    # Unable to find the parser give hints
    class ResponseParserNotFound < NameError
      def initialize(name, namespace)
        super("Unable to find #{name.inspect} parser in #{namespace}")
      end
    end
  end
end

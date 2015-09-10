require 'cogitate/client/exceptions'

module Cogitate
  module Client
    # Responsibl
    module ResponseParsers
      def self.fetch(name)
        return name if name.respond_to?(:call)
        const_get("#{name}Extractor")
      rescue NameError
        raise Client::ResponseParserNotFound.new(name, self)
      end
    end
  end
end

Dir.glob(File.expand_path('../response_parsers/**/*', __FILE__)).each do |filename|
  require filename
end

require 'json'
module Cogitate
  module Client
    module ResponseParsers
      # Responsible for parsing a Cogitate response with a focus on getting emails
      module EmailExtractor
        def self.call(response:)
          data = JSON.parse(response).fetch('data')
          data.each_with_object({}) do |datum, mem|
            mem[datum.fetch('id')] = datum.fetch('attributes').fetch('emails')
            mem
          end
        end
      end
    end
  end
end

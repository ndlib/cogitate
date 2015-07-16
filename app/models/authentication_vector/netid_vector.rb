require 'contracts'
require 'cogitate/interfaces'
module AuthenticationVector
  # The attributes related to an Netid authentication vector
  class NetidVector
    include Contracts
    Contract(Hash => Cogitate::Interfaces::AuthenticationVectorNetidInterface)
    def initialize(attributes)
      attributes.each_pair do |key, value|
        send("#{key}=", value)
      end
      self
    end

    attr_reader :first_name, :last_name, :netid, :full_name, :ndguid

    private

    attr_writer :first_name, :last_name, :netid, :full_name, :ndguid
  end
end

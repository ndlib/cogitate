require 'contracts'
require 'cogitate/interfaces'
module AuthenticationVector
  # The attributes related to an Netid authentication vector
  class NetidVector
    include Contracts
    Contract(Hash => Cogitate::Interfaces::AuthenticationVectorNetidInterface)
    def initialize(identifier:, **attributes)
      self.identifier = identifier
      attributes.each_pair do |key, value|
        send("#{key}=", value) if respond_to?("#{key}=", true)
      end
      self
    end

    attr_reader :first_name, :last_name, :netid, :full_name, :ndguid

    extend Forwardable
    include Comparable
    def_delegators :identifier, :strategy, :<=>

    # TODO: Should we guard that the identifying_value and the netid are the same?
    alias_method :identifying_value, :netid

    private

    attr_accessor :identifier

    attr_writer :first_name, :last_name, :netid, :full_name, :ndguid
  end
end

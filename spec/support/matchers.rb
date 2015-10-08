require 'contracts'
module Cogitate
  module RSpecMatchers
    # Does the licensee adhear to the given contract?
    class ContractuallyHonorMatcher
      def initialize(contract)
        @contract = contract
      end

      def matches?(licensee)
        @licensee = licensee
        Contract.valid?(@licensee, @contract)
      end

      def description
        "expected to honor the #{@contract.inspect} contract"
      end

      def failure_message
        "expected #{@licensee} to honor #{@contract.inspect} contract"
      end
    end

    def contractually_honor(contract)
      ContractuallyHonorMatcher.new(contract)
    end
  end
end

# NOTE: mock class for supplier bar API client
# The actual integration with the supplier's API is not relevant right now
# It is meant to be just a placeholder to help implement the FulfillOrdersJob functionality
module SupplierBarApi
  class Client
    include Singleton

    Error = Class.new(StandardError)

    class << self
      delegate :stock, :fulfill, to: :instance
    end

    # @param [String] product_name
    # @return [Integer] stock level
    def stock(product_name:)
      raise(Error, 'stock error') if product_name.length % 5 == 0

      product_name.length % 2 == 0 ? rand(1..99) : 0
    end

    # @param [String] product_name
    # @return [String] supplier's fulfillment reference
    def fulfill(product_name:)
      SecureRandom.uuid
    end
  end
end

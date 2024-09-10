# NOTE: mock class for supplier foo API client
# The actual integration with the supplier's API is not relevant right now
# It is meant to be just a placeholder to help implement the FulfillOrdersJob functionality
module SupplierFooApi
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

      product_name.length % 3 == 0 ?  0 : rand(1..500)
    end

    # @param [String] product_name
    # @return [String] supplier's fulfillment reference
    def fulfill(product_name:)
      SecureRandom.uuid
    end
  end
end

require 'supplier_bar_api/client'
require 'supplier_foo_api/client'

class FulfillOrdersJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Order.transaction do
      Order.pending.each do |order|
        fulfill_order(order)
      end
    end
  end

  private

  def fulfill_order(order)
    Rails.logger.info "Fulfilling to fulfill order for #{order.customer_name}"

    fulfilling_supplier = order_fulfilling_supplier(order)

    if fulfilling_supplier
      reference = get_api_client(fulfilling_supplier).fulfill(product_name: order.product.name)

      order.update(
        supplier: fulfilling_supplier,
        supplier_reference: reference,
        state: 'completed'
      )
    else
      Rails.logger.info "Could not find a supplier with stock to fulfill order for #{order.customer_name}".alarmify
    end
  end

  def order_fulfilling_supplier(order)
    Supplier.all.find do |supplier|
      stock = get_api_client(supplier).stock(product_name: order.product.name)
      stock.positive?
    end
  end

  def get_api_client(supplier)
    [
      [supplier_foo, SupplierFooApi::Client],
      [supplier_bar, SupplierBarApi::Client]
    ].find { |e| e[0] == supplier }.last
  end

  def supplier_foo
    Supplier.find_by(name: 'supplier_foo')
  end

  def supplier_bar
    Supplier.find_by(name: 'supplier_bar')
  end
end

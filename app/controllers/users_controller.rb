class UsersController < ActionController::Base
  def index


    Order.includes(:product, :supplier).all do |order|
      pp order
    end

    Order.includes(:product, :supplier)
                  .where.not(supplier: nil)
                  .where(pending: Order.states[:pending])
                  .find_each do |order|

      pp order.to_json
    end
  end
end

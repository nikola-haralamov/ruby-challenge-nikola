module HasState
  extend ActiveSupport::Concern

  included do
    enum state: {
      pending: 0,
      completed: 1,
    }.freeze
  end
end

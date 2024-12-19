class CleanupCartJob < ApplicationJob
  queue_as :default

  def perform
    abandoned_time = 3.hours.ago
    delete_time = 7.days.ago

    # Select abandoned carts
    Cart.where('updated_at < ? AND status IS NULL', abandoned_time).update_all(status: 'abandoned')

    # Delete abandoned carts after a week
    Cart.where('updated_at < ? AND status = ?', delete_time, 'abandoned').delete_all
  end
end

class DashboardController < ApplicationController
  def index
    @my_store = current_user.store
    @recent_items = current_user.items.order(created_at: :desc).limit(5)
    @conversations = current_user.conversations.includes(:messages)
                                  .order(updated_at: :desc).limit(5)
  end
end

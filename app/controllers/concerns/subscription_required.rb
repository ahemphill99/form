module SubscriptionRequired
  extend ActiveSupport::Concern

  included do
    before_action :check_subscription
  end

  private

  def check_subscription
    return if controller_name == 'subscriptions'
    return if current_user&.active_subscription?
    return if current_user&.trial_ends_at&.future?

    redirect_to pricing_path, alert: "Please subscribe to access this feature."
  end
end

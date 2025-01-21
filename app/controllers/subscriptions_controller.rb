class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_subscription, only: [:show, :destroy]

  def show
  end

  def new
    @stripe_publishable_key = Rails.configuration.stripe[:publishable_key]
    @stripe_price_id = 'price_monthly' # This should match your Stripe price ID
  end

  def create
    # Ensure we have a Stripe customer
    if current_user.customer.nil?
      customer = Pay::Customer.create(owner: current_user, processor: :stripe)
    else
      customer = current_user.customer
    end

    # Create the subscription
    subscription = customer.subscribe(
      name: 'default',
      plan: params[:plan_id],
      trial_period_days: remaining_trial_days
    )

    redirect_to root_path, notice: 'Successfully subscribed!'
  rescue Pay::Error => e
    redirect_to pricing_path, alert: e.message
  end

  def destroy
    @subscription.cancel

    redirect_to root_path, notice: 'Your subscription has been cancelled.'
  end

  private

  def set_subscription
    @subscription = current_user.subscription
  end

  def remaining_trial_days
    return 0 if current_user.trial_expired?
    ((current_user.trial_ends_at - Time.current) / 1.day).to_i
  end
end

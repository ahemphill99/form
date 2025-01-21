class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_many :pay_customers, as: :owner, class_name: "::Pay::Customer"
  has_many :pay_subscriptions, through: :pay_customers, class_name: "::Pay::Subscription"
  has_many :pay_charges, through: :pay_customers, class_name: "::Pay::Charge"

  has_many :forms, dependent: :destroy

  after_create :create_free_trial

  def active_subscription?
    subscription && subscription.active?
  end

  def subscription
    pay_subscriptions.active.last
  end

  def trial_expired?
    trial_ends_at.present? && trial_ends_at < Time.current
  end

  def customer
    pay_customers.last
  end

  def payment_processor
    customer&.payment_processor
  end

  private

  def create_free_trial
    update(trial_ends_at: 14.days.from_now)
  end
end

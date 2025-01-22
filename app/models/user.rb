class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :forms, dependent: :destroy
  has_many :pay_customers, as: :owner, class_name: "Pay::Customer"
  has_many :subscriptions, through: :pay_customers, class_name: "Pay::Subscription"
  has_many :charges, through: :pay_customers, class_name: "Pay::Charge"

  after_create :create_free_trial

  def active_subscription?
    subscription.present? || trial_ends_at&.future?
  end

  def subscription
    subscriptions.active.last
  end

  def trial_expired?
    trial_ends_at.nil? || trial_ends_at.past?
  end

  def payment_processor
    pay_customers.first&.payment_processor
  end

  def customer
    pay_customers.first
  end

  def processor
    customer&.payment_processor
  end

  pay_customer stripe_attributes: :stripe_attributes

  def stripe_attributes(pay_customer)
    {
      address: {
        city: pay_customer.owner.city,
        country: pay_customer.owner.country
      },
      metadata: {
        pay_customer_id: pay_customer.id,
        user_id: id
      }
    }
  end

  private

  def create_free_trial
    update(trial_ends_at: 14.days.from_now)
  end
end

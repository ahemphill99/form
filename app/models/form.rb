class Form < ApplicationRecord
  belongs_to :user
  has_many :questions, dependent: :destroy
  has_many :form_responses, dependent: :destroy
  
  validates :title, presence: true
  validates :public_token, presence: true, uniqueness: true
  
  before_validation :set_public_token, on: :create

  def to_param
    public_token
  end

  def embed_code(host = nil)
    url = if host
      Rails.application.routes.url_helpers.public_form_url(public_token, host: host)
    else
      Rails.application.routes.url_helpers.public_form_path(public_token)
    end
    %Q(<iframe src="#{url}" width="100%" height="600" frameborder="0"></iframe>)
  end

  private

  def set_public_token
    return if public_token.present?
    self.public_token = SecureRandom.hex(16)
  end
end

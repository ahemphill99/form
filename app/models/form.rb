class Form < ApplicationRecord
  belongs_to :user
  has_many :questions, dependent: :destroy
  has_many :form_responses, dependent: :destroy
  has_one_attached :logo
  
  validates :title, presence: true
  validates :public_token, presence: true, uniqueness: true
  validates :width, numericality: { greater_than: 0, less_than_or_equal_to: 1200 }, allow_nil: true
  validates :height, numericality: { greater_than: 0, less_than_or_equal_to: 2000 }, allow_nil: true
  validates :background_color, format: { with: /\A#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})\z/, message: "must be a valid hex color code" }, allow_blank: true
  validates :font_color, format: { with: /\A#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})\z/, message: "must be a valid hex color code" }, allow_blank: true
  
  validates :logo,
    content_type: { in: [:png, :jpg, :jpeg], message: 'must be a PNG, JPG, or JPEG' },
    size: { less_than: 5.megabytes, message: 'must be less than 5MB' },
    if: :logo_attached?
  
  before_validation :set_public_token, on: :create
  before_validation :set_default_colors
  before_validation :set_default_dimensions

  def to_param
    public_token
  end

  def embed_code(host = nil)
    url = if host
      Rails.application.routes.url_helpers.form_url(self, host: host)
    else
      Rails.application.routes.url_helpers.form_path(self)
    end
    %Q(<iframe src="#{url}" width="#{width || 600}" height="#{height || 800}" frameborder="0"></iframe>)
  end

  private

  def logo_attached?
    logo.attached?
  end

  def set_default_colors
    self.background_color ||= "#ffffff"
    self.font_color ||= "#000000"
  end

  def set_default_dimensions
    self.width ||= 600
    self.height ||= 800
  end

  def set_public_token
    self.public_token = SecureRandom.urlsafe_base64(16)
  end
end

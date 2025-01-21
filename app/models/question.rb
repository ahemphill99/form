class Question < ApplicationRecord
  belongs_to :form
  has_many :question_responses, dependent: :destroy
  
  validates :question_text, presence: true
  validates :question_type, presence: true
  
  enum :question_type, {
    text: 0,
    textarea: 1,
    number: 2,
    select: 3,
    radio: 4,
    checkbox: 5,
    date: 6,
    email: 7
  }, prefix: true

  acts_as_list scope: :form, column: :order

  serialize :options, coder: YAML

  def options
    super || []
  end

  def response_for(form_response)
    question_responses.find_by(form_response: form_response)
  end
end

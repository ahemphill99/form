class FormResponse < ApplicationRecord
  belongs_to :form
  has_many :question_responses, dependent: :destroy
  
  validates :status, presence: true
  
  enum :status, { draft: 0, submitted: 1, approved: 2, rejected: 3 }
  
  accepts_nested_attributes_for :question_responses
  
  def response_for_question(question_id)
    question_responses.find_by(question_id: question_id)&.response
  end
end

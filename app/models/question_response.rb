class QuestionResponse < ApplicationRecord
  belongs_to :form_response
  belongs_to :question

  validates :response, presence: true, if: -> { question.required? }
end

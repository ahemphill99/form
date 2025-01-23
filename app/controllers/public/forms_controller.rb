module Public
  class FormsController < ApplicationController
    skip_before_action :authenticate_user!
    layout "embedded"

    def show
      @form = Form.find_by!(public_token: params[:public_token])
      @questions = @form.questions.order(:order)
      render :embedded
    end

    def submit
      @form = Form.find_by!(public_token: params[:public_token])

      # Create form response
      @form_response = @form.form_responses.build(status: :submitted)

      # Build question responses
      @form.questions.each do |question|
        answer = params["question_#{question.id}"]
        if answer.present? || question.required?
          @form_response.question_responses.build(
            question: question,
            response: answer
          )
        end
      end

      if @form_response.save
        redirect_to thank_you_form_path(@form)
      else
        # If save fails, re-render the form with errors
        @questions = @form.questions.order(:order)
        render :embedded
      end
    end

    def thank_you
      @form = Form.find_by!(public_token: params[:public_token])
    end

    private

    def set_form
      @form = Form.find_by!(public_token: params[:id])
    end
  end
end

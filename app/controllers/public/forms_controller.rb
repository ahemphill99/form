module Public
  class FormsController < ApplicationController
    skip_before_action :authenticate_user!
    layout "public"

    before_action :set_form, only: [ :show, :submit, :review ]

    def index
      # Landing page
    end

    def show
      if @form.nil?
        redirect_to root_path, alert: "Form not found."
      else
        @just_completed = session.delete(:form_completed)
        
        # Clear any old form responses when starting fresh
        session.delete(:form_responses) unless @just_completed
        
        if @just_completed
          flash.now[:notice] = @form.completion_message
        else
          # Redirect to first question if form is not completed
          first_question = @form.questions.order(:order).first
          if first_question
            redirect_to public_form_question_path(@form, first_question)
          end
        end
      end
    end

    def review
      @responses = session[:form_responses] || {}
    end

    def submit
      @form_response = @form.form_responses.build(status: :submitted)

      # Get responses from session
      responses = session[:form_responses] || {}
      
      # Create question responses
      ActiveRecord::Base.transaction do
        if @form_response.save
          responses.each do |question_id, response_text|
            @form_response.question_responses.create!(
              question_id: question_id,
              response: response_text
            )
          end
          
          # Clear session after successful submission
          session.delete(:form_responses)
          session[:form_completed] = true
          redirect_to public_form_path(@form), notice: "Form submitted successfully."
        else
          redirect_to review_public_form_path(@form), alert: "Something went wrong. Please try again."
        end
      end
    rescue ActiveRecord::RecordInvalid
      redirect_to review_public_form_path(@form), alert: "Something went wrong. Please try again."
    end

    private

    def set_form
      @form = Form.find_by!(public_token: params[:public_token])
    end
  end
end

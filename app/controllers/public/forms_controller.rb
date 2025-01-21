module Public
  class FormsController < ApplicationController
    skip_before_action :authenticate_user!
    layout "public"

    def index
      # Landing page
    end

    def show
      Rails.logger.debug "Params: #{params.inspect}"
      Rails.logger.debug "Form token: #{params[:public_token]}"
      @form = Form.find_by!(public_token: params[:public_token])
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

    def review
      Rails.logger.debug "Params: #{params.inspect}"
      Rails.logger.debug "Form token: #{params[:public_token]}"
      @form = Form.find_by!(public_token: params[:public_token])
      @responses = session[:form_responses] || {}
      @questions = @form.questions.order(:order)
    end

    def submit
      Rails.logger.debug "Params: #{params.inspect}"
      Rails.logger.debug "Form token: #{params[:public_token]}"
      @form = Form.find_by!(public_token: params[:public_token])
      @form_response = @form.form_responses.build(
        status: :submitted,
        response_data: session[:form_responses] || {}
      )

      if @form_response.save
        # Clear session after successful submission
        session.delete(:form_responses)
        session[:form_completed] = true
        redirect_to public_form_path(@form), notice: @form.completion_message
      else
        redirect_to review_public_form_path(@form), alert: "Something went wrong. Please try again."
      end
    end

    private

    def form_response_params
      params.require(:form_response).permit(:name, :email, :phone, answers_attributes: [ :question_id, :response_text ])
    end
  end
end

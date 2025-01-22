module Public
  class QuestionsController < ApplicationController
    skip_before_action :authenticate_user!
    layout "public"

    def show
      Rails.logger.debug "Params: #{params.inspect}"
      Rails.logger.debug "Form token: #{params[:form_public_token]}"
      @form = Form.find_by!(public_token: params[:form_public_token])
      @question = @form.questions.find(params[:id])
      @form_response = @form.form_responses.build
      @current_index = @form.questions.order(:order).index(@question)
      @total_questions = @form.questions.count
      @next_question = @form.questions.order(:order)[@current_index + 1]
    end

    def answer
      Rails.logger.debug "Params: #{params.inspect}"
      Rails.logger.debug "Form token: #{params[:form_public_token]}"
      @form = Form.find_by!(public_token: params[:form_public_token])
      @question = @form.questions.find(params[:id])
      @current_index = @form.questions.order(:order).index(@question)
      @next_question = @form.questions.order(:order)[@current_index + 1]
      
      # Initialize form responses in session if not present
      session[:form_responses] ||= {}
      
      # Store the response in session
      response_text = params.dig(:answer, :response)
      if response_text.present?
        session[:form_responses][@question.id.to_s] = response_text
      elsif @question.required?
        flash[:alert] = "Please provide a response"
        redirect_to public_form_question_path(@form, @question) and return
      end

      if @next_question
        redirect_to public_form_question_path(@form, @next_question)
      else
        redirect_to review_public_form_path(@form)
      end
    end
  end
end

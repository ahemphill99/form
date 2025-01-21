module Public
  class FormResponsesController < ApplicationController
    skip_before_action :authenticate_user!
    layout 'public'

    def create
      @form = Form.find_by!(public_token: params[:form_id])
      @form_response = @form.form_responses.build(form_response_params)
      @form_response.status = :submitted

      if @form_response.save
        flash[:notice] = 'Thank you for submitting the form!'
        redirect_to public_form_path(@form)
      else
        flash[:error] = @form_response.errors.full_messages.join(', ')
        redirect_to public_form_path(@form)
      end
    end

    private

    def form_response_params
      params.require(:form_response).permit(response_data: {})
    end
  end
end

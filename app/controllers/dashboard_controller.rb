class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @forms = current_user.forms.includes(:questions, :form_responses).order(created_at: :desc)
  end

  def all_responses
    @forms = current_user.forms.includes(:form_responses)
    @responses = FormResponse.joins(:form)
                           .where(forms: { user_id: current_user.id })
                           .includes(:form)
                           .order(created_at: :desc)
  end
end

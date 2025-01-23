class FormsController < ApplicationController
  include SubscriptionRequired

  before_action :authenticate_user!
  before_action :set_form, only: [ :show, :edit, :update, :destroy, :responses ]

  def index
    @forms = current_user.forms.order(created_at: :desc)
  end

  def show
    @questions = @form.questions.order(:order)
  end

  def new
    @form = current_user.forms.build
  end

  def edit
    @questions = @form.questions.order(:order)
  end

  def create
    @form = current_user.forms.build(form_params)

    if @form.save
      redirect_to form_url(@form), notice: "Form was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @form.update(form_params)
      redirect_to form_url(@form), notice: "Form was successfully updated."
    else
      @questions = @form.questions.order(:order)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @form.destroy
    redirect_to forms_url, notice: "Form was successfully deleted."
  end

  def responses
    @responses = @form.form_responses.includes(:question_responses).order(created_at: :desc)
  end

  private

  def set_form
    @form = if params[:id].length > 10  # Assume it's a public token if longer than 10 chars
      current_user.forms.find_by!(public_token: params[:id])
    else
      current_user.forms.find(params[:id])
    end
  end

  def form_params
    params.require(:form).permit(:title, :description, :completion_message, :company_name, :logo,
                               :background_color, :font_color, :width, :height)
  end
end

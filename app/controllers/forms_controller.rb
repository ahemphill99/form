class FormsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_form, only: [:show, :edit, :update, :destroy, :responses]

  def index
    @forms = current_user.forms.order(created_at: :desc)
  end

  def show
  end

  def new
    @form = Form.new
  end

  def edit
  end

  def create
    @form = current_user.forms.build(form_params)

    if @form.save
      redirect_to @form, notice: 'Form was successfully created.'
    else
      render :new
    end
  end

  def update
    if @form.update(form_params)
      redirect_to @form, notice: 'Form was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @form.destroy
    redirect_to forms_url, notice: 'Form was successfully deleted.'
  end

  def responses
    @responses = @form.form_responses.order(created_at: :desc)
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
    params.require(:form).permit(:title, :description, :completion_message)
  end
end

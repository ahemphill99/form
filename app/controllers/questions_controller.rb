class QuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_form
  before_action :set_question, only: [:show, :edit, :update, :destroy, :move]

  def index
    @questions = @form.questions.order(:order)
  end

  def show
  end

  def new
    @question = @form.questions.build
  end

  def edit
  end

  def create
    @question = @form.questions.build(question_params)
    @question.order = @form.questions.count

    if @question.save
      redirect_to form_path(@form), notice: 'Question was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @question.update(question_params)
      redirect_to form_path(@form), notice: 'Question was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @question.destroy
    redirect_to form_path(@form), notice: 'Question was successfully deleted.'
  end

  def move
    new_order = params[:order].to_i
    if new_order >= 0 && new_order < @form.questions.count
      @question.insert_at(new_order + 1)
    end
    redirect_to form_path(@form)
  end

  private

  def set_form
    @form = current_user.forms.find_by!(public_token: params[:form_id])
  end

  def set_question
    @question = @form.questions.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:question_text, :question_type, :required)
  end
end

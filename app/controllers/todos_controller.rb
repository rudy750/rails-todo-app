class TodosController < ApplicationController
  before_action :set_todo, only: [:show, :edit, :update, :destroy, :toggle]

  # GET /todos
  def index
    @todos = Todo.recent
    @todo = Todo.new
  end

  # GET /todos/:id
  def show
  end

  # GET /todos/new
  def new
    @todo = Todo.new
  end

  # GET /todos/:id/edit
  def edit
  end

  # POST /todos
  def create
    @todo = Todo.new(todo_params)

    respond_to do |format|
      if @todo.save
        format.html { redirect_to root_path, notice: "Todo was successfully created." }
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("new_todo_form", partial: "todos/form", locals: { todo: @todo }) }
      end
    end
  end

  # PATCH/PUT /todos/:id
  def update
    respond_to do |format|
      if @todo.update(todo_params)
        format.html { redirect_to root_path, notice: "Todo was successfully updated." }
        format.turbo_stream
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.turbo_stream
      end
    end
  end

  # DELETE /todos/:id
  def destroy
    @todo.destroy!

    respond_to do |format|
      format.html { redirect_to root_path, notice: "Todo was successfully deleted." }
      format.turbo_stream
    end
  end

  # PATCH /todos/:id/toggle
  def toggle
    @todo.toggle_completion!

    respond_to do |format|
      format.html { redirect_to root_path }
      format.turbo_stream
    end
  end

  private

  def set_todo
    @todo = Todo.find(params[:id])
  end

  def todo_params
    params.require(:todo).permit(:title, :description, :completed, :due_date)
  end
end

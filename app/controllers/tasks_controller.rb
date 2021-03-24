class TasksController < ApplicationController
  include SessionsHelper
  before_action :require_user_logged_in, only: [:index, :show, :new, :edit]
  before_action :correct_user, only: [:show, :edit, :update, :destroy]
  
  def index
      @tasks = current_user.tasks.all
  end

  def show
      @task = Task.find(params[:id])
  end

  def new
      @task = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)
    
    if @task.save
      flash[:success] = 'タスクが正常に登録されました'
      redirect_to @task
    else
      flash.now[:danger] = 'タスクが登録されませんでした'
      render :new
    end
  end

  def update
    @task = Task.find(params[:id])
    
    if @task.update(task_params)
      flash[:success] = 'タスクは正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'タスクは更新されませんでした'
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    
    flash[:success] = 'タスクは正常に削除されました'
    redirect_to tasks_url
  end
  
  private

  #Strong Parameter
  def task_params
    params.require(:task).permit(:content, :status)
  end
  
  def require_user_logged_in
    unless logged_in?
      redirect_to login_url
    end
  end
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
  
end
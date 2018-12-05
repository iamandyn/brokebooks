class UsersController < ApplicationController
  before_action :find_user, only: [:show, :edit, :update]

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    redirect_to root_url and return unless @user.activated?
  end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      @user.send_activation_email
  		flash[:success] = "Please confirm your e-mail address."
  		redirect_to root_url
  	else
  		render 'new'
  	end
  end

  def edit
    if current_user.id != @user.id
      redirect_to root_url
    else
      @emailAlert = false
    end
  end

  def update
    if @user.update(user_params)
      redirect_to @user
    else
      @emailAlert = true
      render 'edit'
    end
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:fname, :lname, :email, :password, :password_confirmation, :image, :remove_image)
  end
    
end
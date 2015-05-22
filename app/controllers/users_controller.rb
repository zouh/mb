 class UsersController < ApplicationController

  # before_action :signed_in_user,  only: [ :index, :edit, :update, :destroy, :qrcode, :rewards ]
  # before_action :correct_user,    only: [ :edit, :update ]
  # before_action :admin_user,      only: :destroy
  before_action :set_user,        only: [ :show, :edit, :update, :destroy, :qrcode, :rewards ]

  def new
  	@user = User.new
  end

  def index
    if current_user.admin?
      @users = User.paginate(page: params[:page])
    elsif current_member.master?
      @users = User.by_organization(current_user.organization_id).paginate(page: params[:page]) 
    end
  end

  def show
  end

  def create
    if @user.save
      sign_in @user    
      flash[:success] = "欢迎您使用微推客！"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "帐户信息已更新！"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "帐户已被删除！"
    redirect_to users_url
  end

  def qrcode
    render 'qrcode'
  end
  
  # def rewards
  #   @title = "返利"
  #   @rewards = @member.rewards.order(created_at: :desc).paginate(page: params[:page])
  #   #@rewards = Reward.select("member_id, order_id, created_at, created_by, sum(amount) as amount, rate, sum(points) as points").where("member_id = ?", @member.id).group("member_id").group("order_id").order(created_at: :desc).paginate(page: params[:page])
  #   render 'show_rewards'
  # end

  private

    def user_params
      params.require(:user).permit(:name, :email, :phone, :password, :password_confirmation)
    end

    def set_user
      @user = User.find(params[:id])
    end

    # Before filters
    def correct_user
      begin
        @user = User.find(params[:id])
      rescue ActiveRecord::RecordNotFound 
        @user = current_user
      end
      redirect_to(root_path) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
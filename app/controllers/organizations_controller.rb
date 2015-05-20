class OrganizationsController < ApplicationController
  
  before_action :get_organization, only: [:show, :edit, :update, :destroy ]

  def new
    @organization = Organization.new
  end

  def index
    @organizations = Organization.paginate(page: params[:page])
  end

  def show
  end

  def create
    @organization = current_user.organizations.build(organization_params)
    if @organization.save
      flash[:success] = "推客群创建成功!"
      redirect_to @organization
    else
      render 'new'
    end
  end

  def edit
    # @organization.updated_by = current_user.id
  end

  def update
    # @organization.updated_by = current_user.id
    if @organization.update_attributes(organization_params)
      flash[:success] = '推客群属性已更新！'
      redirect_to @organization
    else
      render 'edit'
    end
  end

  def destroy
    @organization.destroy
    flash[:success] = "推客群已被删除！"
    redirect_to organizations_url
  end
  

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def organization_params
      params.require(:organization).permit(:name, :contract, :logo_url, :capacity, :level, :period, :org_id, 
                                           :initial_id, :app_id, :weixin_secret_key, :weixin_token, :encoding_aes_key, 
                                           :qy_secret_key, :qy_token, :corp_id, :created_by, :updated_by)
    end

    # Use callbacks to share common setup or constraints between actions.
    def get_organization
      @organization = Organization.find(params[:id])
    end  
end

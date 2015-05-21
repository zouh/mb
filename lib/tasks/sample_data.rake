namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
  	make_organizations
    make_users
  end
end


def make_users
  # 系统管理员
  User.create!(
                name: '系统管理员',
                email: "zouh@meeket.com",
                phone: '18910888104',
                role: 'admin',
                admin: true,
                organization_id: 1
              )
  # # 码客群管理员
  # User.create!(
  #               name: "码客管理员",
  #               email: "admin@meeket.com",
  #               phone: "18910962226",
  #               password: "123456",
  #               password_confirmation: "123456"
  #             )

      # # 微信帐号信息
      # t.boolean    :subscribe, default: false
      # t.string     :openid
      # t.string     :nickname
      # t.integer    :sex, default: 0
      # t.string     :language
      # t.string     :city
      # t.string     :province
      # t.string     :country
      # t.string     :headimgurl
      # t.integer    :subscribe_time
      # t.string     :unionid

      # # 补充信息
      # t.string     :name 
      # t.string     :password_digest
      # t.string     :remember_token
      # t.string     :wechat
      # t.string     :email
      # t.string     :phone     
      # t.boolean    :admin, default: false
      # t.integer    :role, default: 0
      # t.string     :qrcode_url
      # t.integer    :parent_id
      # t.belongs_to :organization, index: true

      # # 码客帐号
      # t.integer    :meeket_id
end

def make_organizations
  #创建码客群
  meeket = Organization.create!(
                                  name: "码客会员俱乐部",
                                  logo_url: "http://www.meeket.com/images/common/logo.png", 
                                  initial_id: 'gh_1c185bc54b3f',
                                  weixin_secret_key: 'b41c825fdf3dd3e3d51a42a6526b50ff',
                                  weixin_token: 'c9d856b5469fc63afa007f31',
                                  app_id: 'wxcc4c37da7948edc4',
                                  encoding_aes_key: 'fXjEvuDa2dMdiV8NcLGTo0m5RrWQ88SUe1msBUBBqBM',
                                  org_id: 1,
                                  created_by: 1,
                                  updated_by: 1
                                )

  test = Organization.create!(
                                  name: "今日工程机械财富帮",
                                  logo_url: "http://www.cmtoday.cn/statics/images/top_logo.png", 
                                  initial_id: 'gh_23184a4f0892',
                                  weixin_secret_key: '0601b8947c0cac7d1680bb40b674a9c4',
                                  weixin_token: 'c9d856b5469fc63afa007f31',
                                  app_id: 'wx93312b406088cd15',
                                  encoding_aes_key: 'fXjEvuDa2dMdiV8NcLGTo0m5RrWQ88SUe1msBUBBqBM',
                                  org_id: 1,
                                  created_by: 1,
                                  updated_by: 1
                                )

  # # 创建码客群管理员
  # master = User.find(2)
  # mb = Member.find(1)
  # mb.update!(user_id: master.id, name: master.name, role: 2)
end



class Organization < ActiveRecord::Base
  has_many :users
  # 自定义菜单
  has_many :diymenus, dependent: :destroy

  # 当前公众账号的所有父级菜单
  has_many :parent_menus, ->{includes(:sub_menus).where(parent_id: nil, is_show: true).order('sort').limit(3)}, class_name: 'Diymenu', foreign_key: :organization_id

  belongs_to :created_by_user, class_name: 'User', foreign_key: 'created_by'
  belongs_to :updated_by_user, class_name: 'User', foreign_key: 'updated_by'

  validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
  validates :capacity, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 50000, only_integer: true}
  validates :level, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 6, only_integer: true}
  validates :encoding_aes_key, length: { maximum: 43 }
  validates :created_by, presence: true

  after_create :generate_weixin_menu

  private

    def generate_weixin_menu 
      # user = 1.to_s
      host = 'https://weituike.herokuapp.com'

      key = host + "/organizations/#{id.to_s}/activities"
      menu0 = diymenus.create!(name: '推广活动', url: key, is_show: true, sort: 0)
      key = 'members'
      menu10 = diymenus.create!(name: '码客会员', key: key, is_show: true, sort: 10)
      key = 'http://fy.meeket.com/flyer/5004/21571.html'
      menu11 = diymenus.create!(name: '什么是码客会员', parent_id: menu10.id, url: key, is_show: true, sort: 11)    
      key = host + '/signup'
      menu12 = diymenus.create!(name: '成为码客会员', parent_id: menu10.id, key: key, is_show: true, sort: 12)
      key = host + '/users/#{user}/activities'
      menu13 = diymenus.create!(name: '我的推广', parent_id: menu10.id, key: key, is_show: true, sort: 13)
      key = host + '/users/#{user}/rewards'
      menu14 = diymenus.create!(name: '我的奖励', parent_id: menu10.id, key: key, is_show: true, sort: 14)
      key = host + '/users/#{user}/qrcode'
      menu15 = diymenus.create!(name: '我的二维码', parent_id: menu10.id, key: key, is_show: true, sort: 15)
      key = 'advertisers'
      menu20 = diymenus.create!(name: '联盟推广', key: key, is_show: true, sort: 20)
      key = 'http://www.meeket.com/pingtai_fuwu.htm'
      menu21 = diymenus.create!(name: '关于联盟推广', parent_id: menu20.id, url: key, is_show: true, sort: 21)
      key = host + '/login'
      menu22 = diymenus.create!(name: '成为联盟成员', parent_id: menu20.id, url: key, is_show: true, sort: 22)
      key = host + '/login'
      menu23 = diymenus.create!(name: '发布推广任务', parent_id: menu20.id, url: key, is_show: true, sort: 23)
      key = host + '/login'
      menu24 = diymenus.create!(name: '查看推广效果', parent_id: menu20.id, url: key, is_show: true, sort: 24)
      key = host + '/login'
      menu25 = diymenus.create!(name: '管理联盟推广', parent_id: menu20.id, url: key, is_show: true, sort: 25)

      weixin_client = WeixinAuthorize::Client.new(app_id, weixin_secret_key)

      if weixin_client.is_valid?
        menu   = build_menu
        result = weixin_client.create_menu(menu)
        # set_error_message(result['errmsg']) if result['errcode'] != 0
      end
    end

    def build_menu
      Jbuilder.encode do |json|
        json.button (parent_menus) do |menu|
          json.name menu.name
          if menu.has_sub_menu?
            json.sub_button(menu.sub_menus) do |sub_menu|
              json.type sub_menu.type
              json.name sub_menu.name
              sub_menu.button_type(json)
            end
          else
            json.type menu.type
            menu.button_type(json)
          end
        end
      end
    end
  
end

class Organization < ActiveRecord::Base
  has_many :users
  # 自定义菜单
  has_many :diymenus, dependent: :destroy

  # 当前公众账号的所有父级菜单
  has_many :parent_menus, ->{includes(:sub_menus).where(parent_id: nil, is_show: true).order("sort").limit(3)}, class_name: "Diymenu", foreign_key: :organization_id

  belongs_to :created_by_user, class_name: "User", foreign_key: "created_by"
  belongs_to :updated_by_user, class_name: "User", foreign_key: "updated_by"

  validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
  validates :level, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 6, only_integer: true}
  validates :created_by, presence: true
  
end

class User < ActiveRecord::Base
  has_closure_tree

  belongs_to :organization, counter_cache: true

  enum role: [ :visitor, :member, :vip, :partner, :angel, :master, :admin ]

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }


  #default_scope { order('organization_id').order('name') }
  scope :by_organization, ->(org_id) {where(organization_id: org_id).order('name')} 

end

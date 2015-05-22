class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|

      # 微信帐号信息
      t.boolean    :subscribe, default: false
      t.string     :openid
      t.string     :nickname
      t.integer    :sex, default: 0
      t.string     :language
      t.string     :city
      t.string     :province
      t.string     :country
      t.string     :headimgurl
      t.integer    :subscribe_time
      t.string     :unionid

      # 补充信息
      t.string     :name 
      t.string     :password_digest
      t.string     :remember_token
      t.string     :wechat
      t.string     :email
      t.string     :phone     
      t.boolean    :admin, default: false
      t.integer    :role, default: 0
      t.string     :qrcode_url
      t.integer    :parent_id, default: 1
      t.belongs_to :organization, index: true

      # 码客用户帐号
      t.integer    :meeket_id

      t.timestamps null: false
    end

    add_index :users, :openid, unique: true
    add_index :users, :unionid
    add_index :users, :remember_token    
    add_index :users, :parent_id
  end
end

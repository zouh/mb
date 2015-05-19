class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string  :name
      t.string  :contract
      t.string  :logo_url
      t.integer :capacity, default: 0
      t.integer :level, default: 0
      t.integer :period, default: 0
      t.integer :users_count, default: 0

      # 微信公众号和企业号支持
      t.string  :initial_id
      t.string  :weixin_secret_key
      t.string  :weixin_token
      t.string  :app_id
      t.string  :encoding_aes_key, limit: 43
      t.string  :qy_secret_key
      t.string  :qy_token
      t.string  :corp_id

      t.integer :created_by
      t.integer :updated_by

      t.timestamps null: false
    end

    add_index :organizations, :name, unique: true
    add_index :organizations, :initial_id
    # add_index :organizations, :weixin_secret_key
    # add_index :organizations, :weixin_token  
    # add_index :organizations, :qy_secret_key
    # add_index :organizations, :qy_token 
  end
end

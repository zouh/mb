class User < ActiveRecord::Base
  has_closure_tree

  belongs_to :organization, counter_cache: true

  enum role: [ :visitor, :member, :vip, :partner, :angel, :master, :admin ]

end

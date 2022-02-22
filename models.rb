require 'bundler/setup'
Bundler.require

ActiveRecord::Base.establish_connection

class User < ActiveRecord::Base
    has_secure_password
    validates :password,
        length: { in: 5..10 }
    has_many :texts
    has_many :favorites, :through => :texts
    has_many :favorite_texts, source: texts
end

class Text < ActiveRecord::Base
    belongs_to :user
    has_many :favorites
    has_many :favorite_users, through => :favorites, source: users
end

class Favorite < ActiveRecord::Base
    belongs_to :user
    belongs_to :text
end


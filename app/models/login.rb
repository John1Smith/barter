class Login < ActiveRecord::Base
	belongs_to :user
	validates :user_login, :password, presence: true	
	validates :password, length: { in: 5..20 }
	validates :user_login, length: { in: 3..30 }
	validates :user_login, uniqueness: { case_sensitive: false }
  
end

class User < ActiveRecord::Base

	#Follow gem
	acts_as_followable
	acts_as_follower

	validates_presence_of :username
	validates_uniqueness_of :username
	
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         :token_authenticatable

  has_many :authentication_tokens

end

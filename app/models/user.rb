class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,:confirmable,:omniauthable, :omniauth_providers => [:facebook]
 has_many :orders,dependent: :destroy 



/#
  validates :first_name, presence: true,on: :update
  validates :first_name, length: {minimum:3} ,if: "first_name.present?",on: :update
  validates :first_name, length: {maximum:100} ,if: "first_name.present?",on: :update



  validates :last_name, presence: true,on: :update
  validates :last_name, length: {minimum:3} ,if: "last_name.present?",on: :update
  validates :last_name, length: {maximum:100} ,if: "last_name.present?",on: :update

  validates :phone_number, presence: true,on: :update
  validates :phone_number, length: {minimum:11} ,if: "phone_number.present?",on: :update
  validates :phone_number, length: {maximum:15} ,if: "phone_number.present?",on: :update
$/



	def self.from_omniauth(auth)

		where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
		user.email = auth.info.email
	    user.first_name=auth.info.first_name
	    user.last_name=auth.info.last_name
	    user.gender = auth.extra.raw_info.gender
    	user.phone_number="00000000000"
    	user.password=Devise.friendly_token[0,20]
      user.has_password=false
      user.profile_icon = auth.info.image
  		user.skip_confirmation!
  		user.save
		#user.name = auth.info.name   # assuming the user model has a name
		#user.image = auth.info.image # assuming the user model has an image
	 end
end


 def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"]) do |user|
        user.attributes=params
        user.valid?
    end
      else
        super
  end
end

end

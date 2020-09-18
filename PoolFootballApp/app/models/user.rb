class User
  include Mongoid::Document
  field :email, type: String
  field :token, type: String
  field :refreshtoken, type: String
  field :accesslevel, type: String

  has_one :pooler, dependent: :destroy

  def self.from_omniauth(auth)
    where(email: auth.info.email).first_or_initialize do |user|
      user.email = auth.info.email
      user.accesslevel = "U";
    end
  end
end

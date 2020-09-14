class User
  include Mongoid::Document
  field :email, type: String
  field :token, type: String
  field :refreshtoken, type: String
  field :accesslevel, type: String

  has_one :pooler, dependent: :destroy
end

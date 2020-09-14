class Pooler
  include Mongoid::Document
  field :email, type: String
  field :name, type: String
  field :favTeam, type: String
  field :token, type: String
  field :refresh_token, type: String
  field :accessLevel, type: String

  belongs_to :pool
end

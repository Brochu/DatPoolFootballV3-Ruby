class Pooler
  include Mongoid::Document
  field :name, type: String
  field :favTeam, type: String

  belongs_to :pool
  belongs_to :user

  has_many :picks, dependent: :destroy
end

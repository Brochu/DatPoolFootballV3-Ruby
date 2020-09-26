class Pooler
  include Mongoid::Document
  field :name, type: String
  field :favTeam, type: String

  belongs_to :pool, optional: true
  belongs_to :user

  has_many :picks, class_name: Pick
end

class Pool
  include Mongoid::Document
  field :name, type: String
  field :motp, type: String

  has_many :poolers, dependent: :destroy
end

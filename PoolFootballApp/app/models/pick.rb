class Pick
  include Mongoid::Document
  field :season, type: Int
  field :week, type: Int
  field :pickstring, type: String

  belongs_to :pooler
  belongs_to :pool
end

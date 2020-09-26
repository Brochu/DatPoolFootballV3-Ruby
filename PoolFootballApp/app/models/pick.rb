class Pick
  include Mongoid::Document
  field :season, type: Integer
  field :week, type: Integer
  field :pickstring, type: String

  belongs_to :pooler
  belongs_to :pool
end

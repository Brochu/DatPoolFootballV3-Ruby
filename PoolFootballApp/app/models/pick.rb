require 'json'

class Pick
  include Mongoid::Document
  field :season, type: Integer
  field :week, type: Integer
  field :pickstring, type: String

  belongs_to :pooler

  def json_picks?
    return pickstring[0] == "{"
  end

  def parse_picks
    if (json_picks?)
      # Handle json object
      JSON.parse(pickstring)
    else
      # Handle string split
      pickstring.split("|")
    end
  end
end

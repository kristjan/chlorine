class Document < ActiveRecord::Base
  has_attachment
  belongs_to :recruit
end

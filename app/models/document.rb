class Document < ActiveRecord::Base
  has_attachment :max_size => 10.megabytes
  belongs_to :recruit

  validates_presence_of :filename, :content_type
  validates_numericality_of :size, :greater_than => 0

  def disposition
    content_type =~ /^(image|text)/ ? 'inline' : 'attachment'
  end
end

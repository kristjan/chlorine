class AddSummaryToFeedback < ActiveRecord::Migration
  extend ActionView::Helpers::TextHelper

  def self.up
    add_column :feedbacks, :summary, :string
    Feedback.all.each do |feedback|
      feedback.update_attribute :summary, truncate(feedback.body, 256)
    end
  end

  def self.down
    remove_column :feedbacks, :summary
  end
end

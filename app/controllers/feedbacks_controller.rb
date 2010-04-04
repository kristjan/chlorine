class FeedbacksController < ApplicationController
  # POST /feedbacks
  # POST /feedbacks.xml
  def create
    @feedback = Feedback.new(params[:feedback])
    @feedback.save!
    flash[:success] = "Thanks for the feedback!"
    redirect_to(@feedback.recruit)
  end
end

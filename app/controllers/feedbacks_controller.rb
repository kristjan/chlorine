class FeedbacksController < ApplicationController

  def create
    @feedback = Feedback.new(params[:feedback])
    @feedback.save!
    type, message = feedback_flash
    flash[type] = message
    redirect_to(@feedback.recruit)
  end

private

  def feedback_flash
    if @feedback.scored?
      case @feedback.score
      when -2...-1: [:failure, "Wow, did they stab you or something?"]
      when -1...0 : [:notice,  "Well, at least they didn't vomit on you."]
      when 0      : [:notice,  "Good decision making, Switzerland."]
      when 0...1  : [:success, "Sounds like they might be worth a second date."]
      when 0..2   : [:success, "Might be time to invest in those kneepads."]
      else [:failure, "Knock knock, Neo."]
      end
    else
      case @feedback.body.length
      when 0     : [:notice, "Thanks, Silent Bob."]
      when 1..500: [:success,"Duly noted!"]
      else
        [:success, "You don't really expect anyone to read all that, do you?"]
      end
    end
  end
end

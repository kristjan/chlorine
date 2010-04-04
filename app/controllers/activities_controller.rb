class ActivitiesController < ApplicationController
  before_filter :set_activity, :except => [:create]

  def update
    activity_key = params.keys.detect{|k| k =~ /^activity/}
    data = params[activity_key]
    data['employee_ids'] ||= []
    @activity.update_attributes!(data)
    flash[:success] = "You are a master of time and space."
    redirect_to @activity.recruit
  end

private

  def set_activity
    @activity = Activity.find(params[:id])
  end
end

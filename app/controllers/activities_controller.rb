class ActivitiesController < ApplicationController
  before_filter :set_activity, :except => [:create]

  include ActionView::Helpers::ActiveRecordHelper

  def update
    activity_key = params.keys.detect{|k| k =~ /^activity/}
    data = params[activity_key]
    data['employee_ids'] ||= []
    if @activity.update_attributes(data)
      flash[:success] = "You are a master of time and space."
    else
      flash[:failure] = formatted_errors(@activity.errors)
    end
    redirect_to @activity.recruit
  end

private

  def set_activity
    @activity = Activity.find(params[:id])
  end
end

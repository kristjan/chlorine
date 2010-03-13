class RecruitsController < ApplicationController
  before_filter :set_recruit,
    :except => [:index, :new, :create, :destroy]
  before_filter :finish_current_activity,
    :only => [:advance, :reject, :decline]

  # GET /recruits
  # GET /recruits.xml
  def index
    @recruits = Recruit.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @recruits }
    end
  end

  # GET /recruits/1
  # GET /recruits/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @recruit }
    end
  end

  # GET /recruits/new
  # GET /recruits/new.xml
  def new
    @recruit = Recruit.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @recruit }
    end
  end

  # GET /recruits/1/edit
  def edit
  end

  # POST /recruits
  # POST /recruits.xml
  def create
    @recruit = Recruit.new(params[:recruit])

    respond_to do |format|
      if @recruit.save
        flash[:notice] = 'Recruit was successfully created.'
        format.html { redirect_to(@recruit) }
        format.xml  { render :xml => @recruit, :status => :created, :location => @recruit }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @recruit.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /recruits/1
  # PUT /recruits/1.xml
  def update
    respond_to do |format|
      if @recruit.update_attributes(params[:recruit])
        flash[:notice] = 'Recruit was successfully updated.'
        format.html { redirect_to(@recruit) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @recruit.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /recruits/1
  # DELETE /recruits/1.xml
  def destroy
    @recruit.destroy

    respond_to do |format|
      format.html { redirect_to(recruits_url) }
      format.xml  { head :ok }
    end
  end

  def advance
    activity = Activity.from_param(params[:activity])
    activity.create!(:recruit => @recruit)
    redirect_to @recruit
  end

  def reject
    Activity::Rejected.create!(
      :recruit => @recruit,
      :completed_at => Time.now)
    redirect_to @recruit
  end

  def decline
    Activity::Declined.create!(
      :recruit => @recruit,
      :completed_at => Time.now)
    redirect_to @recruit
  end

private

  def set_recruit
    @recruit = Recruit.find(params[:id])
  end

  def finish_current_activity
    @recruit.current_activity.finish!
  end

end

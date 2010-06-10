class RecruitsController < ApplicationController
  before_filter :set_recruit,
    :except => [:index, :new, :create, :destroy]
  before_filter :finish_current_activity,
    :only => [:promote, :reject, :decline]

  def index
    @recruits = Recruit.all - [current_user.recruit]
    @recruits_by_stage = @recruits.group_by do |r|
      r.current_activity.pipeline_stage
    end

    unless params[:show] == 'all'
      @recruits.reject! do |r|
        ![:new, :in_process].include?(r.current_activity.pipeline_stage)
      end
    end

    respond_to do |format|
      format.html
      format.xml  { render :xml => @recruits }
    end
  end

  def show
    redirect_to root_path and return if current_user.recruit == @recruit
    respond_to do |format|
      format.html
      format.xml  { render :xml => @recruit }
    end
  end

  def new
    @recruit = Recruit.new

    respond_to do |format|
      format.html
      format.xml  { render :xml => @recruit }
    end
  end

  def edit
  end

  def create
    @recruit = Recruit.new(params[:recruit])

    respond_to do |format|
      if @recruit.save
        flash[:success] = "Boy, I hope #{@recruit.name} is smart!"
        format.html { redirect_to(@recruit) }
        format.xml  { render :xml => @recruit, :status => :created, :location => @recruit }
      else
        flash[:failure] = formatted_errors(@recruit.errors)
        format.html { render :action => "new" }
        format.xml  { render :xml => @recruit.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @recruit.update_attributes(params[:recruit])
        flash[:success] = "#{@recruit.name} likes cheese. Got it."
        format.html { redirect_to(@recruit) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @recruit.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      format.html do
        flash[:failure] =
          "Destruction is a little harsh. How about a polite \"No\"?"
        redirect_to(recruits_path)
      end
      format.xml  { head :no }
    end
  end

  def promote
    @recruit.promote!
    flash[:success] = "#{@recruit.name} has leveled up!"
    redirect_to @recruit
  end

  def demote
    if @recruit.current_activity.feedbacks.any?
      flash[:failure] = "There's already feedback"
    else
      @recruit.demote!
      flash[:success] = "#{@recruit.name} got kicked down a notch!"
    end
    redirect_to @recruit
  end

  def reject
    @recruit.reject!
    flash[:failure] = "#{@recruit.name}'s spoon was just too big."
    redirect_to @recruit
  end

  def decline
    @recruit.decline!
    flash[:failure] = "It was probably something you said."
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

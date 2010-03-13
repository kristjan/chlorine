class RecruitsController < ApplicationController
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
    @recruit = Recruit.find(params[:id])

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
    @recruit = Recruit.find(params[:id])
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
    @recruit = Recruit.find(params[:id])

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
    @recruit = Recruit.find(params[:id])
    @recruit.destroy

    respond_to do |format|
      format.html { redirect_to(recruits_url) }
      format.xml  { head :ok }
    end
  end
end

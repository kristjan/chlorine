class EmployeesController < ApplicationController

  def index
    @employees = Employee.all

    respond_to do |format|
      format.html
      format.xml  { render :xml => @employees }
    end
  end

  def show
    @employee = Employee.find(params[:id])

    respond_to do |format|
      format.html
      format.xml  { render :xml => @employee }
    end
  end

  def new
    @employee = Employee.new

    respond_to do |format|
      format.html
      format.xml  { render :xml => @employee }
    end
  end

  def edit
    @employee = Employee.find(params[:id])
  end

  def create
    @employee = Employee.new(params[:employee])

    respond_to do |format|
      if @employee.save
        flash[:success] = "The system works!"
        format.html { redirect_to employees_path }
        format.xml  { render :xml => @employee, :status => :created, :location => @employee }
      else
        flash[:failure] = "You've made a terrible mistake."
        format.html { render :action => "new" }
        format.xml  { render :xml => @employee.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @employee = Employee.find(params[:id])

    respond_to do |format|
      if @employee.update_attributes(params[:employee])
        flash[:success] = "Gee, 'ts not every day you change uniquely identifying information."
        format.html { redirect_to employees_path }
        format.xml  { head :ok }
      else
        flash[:failure] = "Whatever was there before worked better."
        format.html { render :action => "edit" }
        format.xml  { render :xml => @employee.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @employee = Employee.find(params[:id])
    @employee.destroy

    respond_to do |format|
      flash[:failure] = "I can't help but feel this is a step backwards."
      format.html { redirect_to employees_path }
      format.xml  { head :ok }
    end
  end
end

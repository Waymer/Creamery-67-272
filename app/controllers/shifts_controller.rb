class ShiftsController < ApplicationController
  before_action :set_shift, only: [:show, :edit, :update, :destroy]
  
  def index
    if logged_in?
      @empl_upcoming_shifts = Shift.upcoming.for_employee(current_user.employee).paginate(page: params[:page]).per_page(10)
      @empl_past_shifts = Shift.past.for_employee(current_user.employee).paginate(page: params[:page]).per_page(10)  
    end
    @upcoming_shifts = Shift.upcoming.by_employee.paginate(page: params[:page]).per_page(10)
    @past_shifts = Shift.past.by_employee.paginate(page: params[:page]).per_page(10) 
  end

  def show
    @jobs = @shift.jobs
  end

  def new
    @shift = Shift.new
    @shift.jobs.build
  end

  def edit
  end

  def create
    @shift = Shift.new(shift_params)
    
    if @shift.save
      redirect_to shift_path(@shift), notice: "Successfully created #{@shift.name}."
    else
      render action: 'new'
    end
  end

  def update
    if @shift.update(shift_params)
      redirect_to shift_path(@shift), notice: "Successfully updated #{@shift.name}."
    else
      render action: 'edit'
    end
  end

  def destroy
    @shift.destroy
    redirect_to shifts_path, notice: "Successfully removed #{@shift.name} from the AMC system."
  end

  private
  def set_shift
    @shift = Shift.find(params[:id])
  end

  def shift_params
    params.require(:job).permit(:assignment_id, :date, :start_time, :end_time, :notes, jobs_attributes: [:id, :name, :description, :active, :_destroy])
    #do we include date/start time/end time??
  end

end
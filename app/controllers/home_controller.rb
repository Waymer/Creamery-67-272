class HomeController < ApplicationController

  def home
  	if logged_in?
	  	@employee = current_user.employee
	  	@empl_upcoming_shifts = Shift.upcoming.for_employee(current_user.employee).paginate(page: params[:page]).per_page(10)
	  	@upcoming_shifts = Shift.upcoming.by_employee.paginate(page: params[:page]).per_page(10)
	 end
	 if logged_in? && !current_user.employee.current_assignment.nil? && !current_user.employee.current_assignment.store.nil?
	 	@st_upcoming_shifts = Shift.upcoming.for_store(current_user.employee.current_assignment.store).by_employee.paginate(page: params[:page]).per_page(10)
	 end
  end

  def about
  end

  def privacy
  end

  def contact
  end

end
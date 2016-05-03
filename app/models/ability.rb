class Ability
  include CanCan::Ability
  
  def initialize(user)
    # set user to new User if not logged in
    user ||= User.new # i.e., a guest user
    
    # set authorizations for different user roles
    if user.role? :admin
      # they get to do it all
      can :manage, :all
      
    elsif user.role? :manager
      # can see a list of all things
      can :read, Store
      can :read, Flavor
      can :read, Job
      can :read, Shift do |s|
        if current_assignment.nil?
          return false
        else
          user.employee.current_assignment.store_id == s.assignment.store_id
        end
      end
      can :read, Assignment do |a|
        if current_assignment.nil?
          return false
        else
          user.employee.current_assignment.store_id == a.store_id
        end
      end
      can :read, Employee do |e|
        if current_assignment.nil?
          return false
        else
          user.employee.current_assignment.store_id == e.current_assignment.store_id
        end
      end
      can :create, Shift do |s|
        if current_assignment.nil?
          return false
        else
          user.employee.current_assignment.store_id == s.assignment.store_id
        end
      end
      can :update, Shift do |s|
        if current_assignment.nil?
          return false
        else
          user.employee.current_assignment.store_id == s.assignment.store_id
        end
      end
      can :destroy, Shift do |s|
        if current_assignment.nil?
          return false
        else
          user.employee.current_assignment.store_id == s.assignment.store_id
        end
      end
      # can :update, Employee
      can :create, ShiftJob do |sj|
        if current_assignment.nil?
          return false
        else
          user.employee.current_assignment.store_id == sj.shift.assignment.store_id
        end
      end
      can :destroy, ShiftJob do |sj|
        if current_assignment.nil?
          return false
        else
          user.employee.current_assignment.store_id == sj.shift.assignment.store_id
        end
      end
      can :create, StoreFlavor do |sf|
        if current_assignment.nil?
          return false
        else
          user.employee.current_assignment.store_id == sf.store_id
        end
      end
      can :destroy, StoreFlavor do |sf|
        if current_assignment.nil?
          return false
        else
          user.employee.current_assignment.store_id == sf.store_id
        end
      end
      can :update, User do |u|  
        u.id == user.id
      end
      can :update, Employee do |e|  
        my_employee = user.employee.map(&:id)
        my_employee.include? e.id
      end
    elsif user.role? :employee
      # they can read their own profile
      can :read, User do |u|  
        u.id == user.id
      end
      # they can update their own profile
      can :update, User do |u|  
        u.id == user.id
      end
      can :read, Employee do |e|  
        my_employee = user.employee.map(&:id)
        my_employee.include? e.id
      end
      # they can update their own profile
      can :update, Employee do |e|  
        my_employee = user.employee.map(&:id)
        my_employee.include? e.id
      end
      can :read, Store
      can :read, Flavor
      can :read, Job
      can :read, Assignment do |a|
        my_shifts = user.employee.assignments.map(&:id)
        my_shifts.include? a.id
      end
      can :read, Shift do |s|
        my_shifts = user.employee.shifts.map(&:id)
        my_shifts.include? s.id
      end
      can :read, ShiftJob do |sj|
        my_shiftjobs = user.employee.shifts.shift_jobs.map(&:id)
        my_shiftjobs.include? sj.id
      end
    else
      # guests can only read domains covered (plus home pages)
      # can :read, Domain
      can :read, Store do |s|
        active_stores = Store.active.map(&:id)
        active_stores.include? s.id
      end
    end
  end
end
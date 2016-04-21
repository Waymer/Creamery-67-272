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
      can :index, Flavor
      can :read, Shift
      can :read, Assignment
      can :read, Employee
      can :index, Job

      can :create, Shift
      can :update, Shift
      can :create, Job
      can :update, Job
      can :update, Employee
      # # they can read their own profile
      # can :show, User do |u|  
      #   u.id == user.id
      # end
      # # they can update their own profile
      # can :update, User do |u|  
      #   u.id == user.id
      # end
      
      # # they can read their own projects' data
      # can :read, Project do |this_project|  
      #   my_projects = user.projects.map(&:id)
      #   my_projects.include? this_project.id 
      # end
      # # they can create new projects for themselves
      # can :create, Project
      
      # # they can update the project only if they are the manager (creator)
      # can :update, Project do |this_project|
      #   managed_projects = user.projects.map{|p| p.id if p.manager_id == user.id}
      #   managed_projects.include? this_project.id
      # end
            
      # # they can read tasks in these projects
      # can :read, Task do |this_task|  
      #   project_tasks = user.projects.map{|p| p.tasks.map(&:id)}.flatten
      #   project_tasks.include? this_task.id 
      # end
      
      # # they can update tasks in these projects
      # can :update, Task do |this_task|  
      #   project_tasks = user.projects.map{|p| p.tasks.map(&:id)}.flatten
      #   project_tasks.include? this_task.id 
      # end
      
      # # they can create new tasks for these projects
      # can :create, Task do |this_task|  
      #   my_projects = user.projects.map(&:id)
      #   my_projects.include? this_task.project_id  
      # end
    elsif user.role? :employee
      # they can read their own profile
      can :show, User do |u|  
        u.id == user.id
      end
      # they can update their own profile
      can :update, User do |u|  
        u.id == user.id
      end
      can :show, Employee do |e|  
        my_employee = user.employee.map(&:id)
        my_employee.include? e.id
      end
      # they can update their own profile
      can :update, Employee do |e|  
        my_employee = user.employee.map(&:id)
        my_employee.include? e.id
      end
      can :show, Store
      can :show, Shift do |s|
        my_shifts = user.employee.shifts.map(&:id)
        my_shifts.include? s.id
      end
      # can :show, Assignment do |a|
      #   my_shifts = user.employee.shifts.map(&:id)
      #   my_shifts.include? s.id
      # end
      can :index, Store
      can :index, Flavor
      can :index, Shift do |s|
        my_shifts = user.employee.shifts.map(&:id)
        my_shifts.include? s.id
      end
    else
      # guests can only read domains covered (plus home pages)
      # can :read, Domain
      can :read, Store
      can :read, Flavor
    end
  end
end
class User < ActiveRecord::Base
  # get modules to help with some functionality
  include CreameryHelpers::Validations
  has_secure_password
  # Relationships
  belongs_to :employee

  # Validations
  validates_uniqueness_of :email, case_sensitive: false
  validates_format_of :email, :with => /\A[\w]([^@\s,;]+)@(([\w-]+\.)+(com|edu|org|net|gov|mil|biz|info))\z/i, :message => "is not a valid format"
  validate :employee_is_active_in_system #, :on_update
  
  def self.authenticate(email,password)
    find_by_email(email).try(:authenticate, password)
  end
  def name
    "#{self.employee.first_name} #{self.employee.last_name}"
  end

  def role?(authorized_role)
    # return false if self.employee.current_assignment.role.nil?
    return false if self.employee.role.nil?
    self.employee.role.to_sym == authorized_role
    # self.employee.current_assignment.role.to_sym == authorized_role
  end
  def role
    return self.employee.role
  end
  private
  def employee_is_active_in_system
    is_active_in_system(:employee)
  end

end

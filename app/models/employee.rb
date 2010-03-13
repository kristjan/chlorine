class Employee < ActiveRecord::Base
  has_many :employee_activities
  has_many :activities, :through => :employee_activities
end

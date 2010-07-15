module EmployeesHelper
  def recruits_for_select(recruits, employee=nil)
    result = recruits.map{|r| [r.name, r.id]}
    unless employee.nil? || employee.recruit.nil?
      result << [employee.recruit.name, employee.recruit_id]
    end
    result
  end
end

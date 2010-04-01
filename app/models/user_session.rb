class UserSession < Authlogic::Session::Base
  authenticate_with Employee
  facebook_skip_new_user_creation true
end

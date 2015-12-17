# User sessions
class UserSession < Authlogic::Session::Base
  def to_key
    new_record? ? nil : [send(self.class.primary_key)]
  end
end

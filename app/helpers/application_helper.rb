module ApplicationHelper
  
  def loadjs(ctrl)
    ctrl == "devise/registrations" ? "users" : ctrl    
  end

end

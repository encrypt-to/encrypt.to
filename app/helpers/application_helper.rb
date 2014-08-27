module ApplicationHelper
  
  def loadjs(ctrl)
    ["devise/sessions", "devise/passwords", "registrations"].include?(ctrl) ? "users" : ctrl    
  end

end

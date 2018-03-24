class Api::V1::KeyserverController < ActionController::Metal
  require './lib/keyserver.rb' 
  require './lib/util.rb' 
    
  include ActionController::Helpers
  include ActionController::Redirecting
  include ActionController::Rendering
  include ActionController::Renderers::All
  include ActionController::ConditionalGet
  include ActionController::MimeResponds
  include ActionController::RequestForgeryProtection
  include ActionController::ForceSSL
  include ActionController::ParamsWrapper
  include ActionController::Instrumentation
  include AbstractController::Callbacks
  include Rails.application.routes.url_helpers
 
  protect_from_forgery
    
  def lookup
    if params[:keyid] && params[:keyid].downcase.include?("0x")
      keyids = [params[:keyid].downcase]
    elsif params[:email] && Util.is_email?(params[:email])
      keyids = Keyserver.get_keyids_by_email(params[:email].downcase)
    end
    
    if keyids
      keys = []
      for key in keyids
        keys << {"key_id" => key, "public_key" => Keyserver.get_publickey_by_keyid(key)}      
      end  
      self.response_body = {:status => "success", :keys => keys}.to_json
    else
      self.response_body = {:status => "error", "message" => "Wrong params, please try again."}.to_json
    end
  end
end

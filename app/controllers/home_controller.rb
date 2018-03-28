class HomeController < ApplicationController

  # GET /
  def index
    @count = Message.all.size.to_s
  end

  # GET /terms
  def terms
  end

  # GET /privacy
  def privacy
  end
  
  # GET /blog
  def blog
  end
end

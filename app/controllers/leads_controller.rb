class LeadsController < ApplicationController

  # GET /leads/new
  def new
    @lead = Lead.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # POST /leads
  def create
    @lead = Lead.new(params[:lead])

    respond_to do |format|
      if @lead.save
        format.html { redirect_to "/", notice: 'Thank you!' }
      else
        format.html { render action: "new" }
      end
    end
  end

end

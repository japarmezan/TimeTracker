class ProjectsController < ApplicationController
  before_action :authenticate_user!

  def create
  	@track = Track.new
  end

end
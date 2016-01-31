require 'byebug'
class ProjectsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_project, only: [:show, :edit, :update, :destroy, :start, :stop]
  authorize_actions_for Project, except: [:show,], :actions => {:destroy => :update, :start => :read, :stop => :read}
  # GET /projects
  # GET /projects.json
  def index
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @tracks = @project.tracks.order(created_at: :desc)
    @track = @tracks.first
  end

  # POST /projects/1/start
  def start
    @track = Track.new
    @track.start = DateTime.now
    if @track.save
      @project.tracks << @track
      redirect_to @project, notice: 'Work on project started.'
    else
      redirect_to @project, alert: 'Could not start work on project.'
    end
  end

  # PATCH /projects/1/stop
  def stop
    @track = @project.tracks.order(:created_at).last
    if @track.update(:end => DateTime.now)
      redirect_to @project, notice: 'Work on project stopped.'
    else
      redirect_to @project, alert: 'Could not stop work on project.'
    end
  end

  # GET /projects/new
  def new
    @project = current_user.projects.new
    authorize_action_for @project
    @categories = Category.where(user_id: nil) + current_user.categories
  end

  # GET /projects/1/edit
  def edit
    authorize_action_for @project
    @categories = Category.where(user_id: nil) + current_user.categories
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = current_user.projects.new(project_params)
    authorize_action_for @project
    @project.category_id = category_params
    respond_to do |format|
      if @project.save
        manage_contributors
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        @categories = Category.where(user_id: nil) + current_user.categories
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_track
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    authorize_action_for @project
    @project.category_id = category_params
    respond_to do |format|
      if @project.update(project_params)
        manage_contributors
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        @categories = Category.where(user_id: nil) + current_user.categories
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    authorize_action_for @project
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  # DELETE /tracks/1
  def delete_track
    Track.find(params[:id]).destroy
    redirect_to @project, notice: 'Track was successfully deleted.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find Project.decode_id(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name, :description)
    end

    def contributor_params
      params[:project][:contributors].tr(',', ' ').split
    end

    def category_params
      params[:project][:category_id]
    end

    def manage_contributors
      add_new_contributors
      remove_redundant_contributors
    end

    def add_new_contributors
      contributors = contributor_params
      contributors.each do |c|
        if @project.coworkers.where(:email => c).length == 0 and c != @project.author.email
          @project.coworkers << User.where(:email => c)
        end
      end
    end

    def remove_redundant_contributors
      contributors = contributor_params
      @project.coworkers.each do |c|
        unless contributors.include?(c.email)
          @project.coworkers.delete(c)
        end
      end
    end
end

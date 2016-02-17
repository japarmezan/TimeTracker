# ProjectsController
class ProjectsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_project, only: [:show, :edit, :update, :destroy, :start, :stop]
  authorize_actions_for Project, except: [:show], :actions => {
    :destroy => :update, :start => :read, :stop => :read, :index_collaborate => :read }

  # GET /projects
  # GET /projects.json
  def index
  end

  def index_collaborate
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @tracks = @project.tracks.order(created_at: :desc)

    @track = @tracks.where(user_id: current_user.id).first if user_signed_in?
    @track = @project.tracks.build if @track.nil? || @track.status == 'uploaded'

    @work_time = 0
    @tracks.each do |t|
      @work_time += (t.end - t.start) if t.end && t.start
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
        @project.configure_contributors(contributor_params)
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        @categories = Category.where(user_id: nil) + current_user.categories
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    authorize_action_for @project
    @project.category_id = category_params
    respond_to do |format|
      if @project.update(project_params)
        @project.configure_contributors(contributor_params)
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

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find Project.decode_id(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def project_params
    params.require(:project).permit(:name, :description, :currency, :client)
  end

  def contributor_params
    params[:project][:contributors].tr(',', ' ').split
  end

  def category_params
    params[:project][:category_id]
  end
end

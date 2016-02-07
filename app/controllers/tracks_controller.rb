require 'byebug'
class TracksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:start, :stop, :pause, :resume]
  before_action :set_track, only: [:start, :stop, :pause, :resume]
  before_action :set_track_project, only: [:create, :update]
  authorize_actions_for Project, :actions => {:destroy => :update, :start => :read, :stop => :read, :pause => :read, :resume => :read}
 
 
  # POST /projects/1/start
  def start    
    authorize_action_for @project

    if @track
      redirect_to @project unless @track.status == nil
    end

    @track = @project.tracks.build
    @track.start = DateTime.now
    @track.user_id = current_user.id
    @track.status = 'started'

    if @track.save
      redirect_to @project, notice: 'Work on project started.'
    else
      redirect_to @project, alert: 'Could not start work on project.'
    end
  end

  # PATCH /projects/1/stop
  def stop
    authorize_action_for @project

    if @track
      redirect_to @project unless @track.status == 'started' || @track.status == 'paused' || @track.status == 'resumed'
    end

    if @track.status == 'resumed'
      unless @track.update(:end => DateTime.now, :status => 'stopped')
        redirect_to @project, alert: 'Could not stop work on project.'
      end
    end

    if @track.status == 'paused'
      unless @track.update(:status => 'stopped')
        redirect_to @project, alert: 'Could not stop work on project.'
      end
    end

    tracks = @project.tracks.where(user_id: current_user.id).where(status: 'paused').order(created_at: :desc).all
    if tracks.size > 0
      tracks.each { |t|
        unless t.update(status: 'stopped')
          redirect_to @project, alert: 'Could not stop work on project.'
        end
      }
    end

    redirect_to @project, notice: 'Work on project stopped.'
  end

  # PATCH /projects/1/stop
  def pause
    authorize_action_for @project

    if @track
      redirect_to @project unless @track.status == 'started' || @track.status == 'resumed'
    end

    if @track.update(:end => DateTime.now, :status => 'paused')
      redirect_to @project, notice: 'Work on project paused.'
    else
      redirect_to @project, alert: 'Could not pause work on project.'
    end
  end

  def resume
    authorize_action_for @project

    if @track
      redirect_to @project unless @track.status == 'paused'
    end

    @track = @project.tracks.build
    @track.start = DateTime.now
    @track.user_id = current_user.id
    @track.status = 'resumed'

    if @track.save
      redirect_to @project, notice: 'Work on project resumed.'
    else
      redirect_to @project, alert: 'Could not resume work on project.'
    end
  end

 
  # POST /tracks
  def create
    authorize_action_for @project

    @track = @project.tracks.build(track_params)
    @track.status = 'uploaded'
    @track.user_id = current_user.id

    if @track.save
      redirect_to @project, notice: 'Track successfully added to project.'
    else
      redirect_to @project, alert: 'Could not add track to project.'
    end
  end

  # PATCH/PUT /tracks/1
  def update
    authorize_action_for @project
    tracks = @project.tracks.where(user_id: current_user.id).where(status: 'stopped').order(created_at: :desc).all

    tracks.each { |t|
      unless t.update(comment: params[:track][:comment], status: 'uploaded')
        redirect_to @project, alert: 'Could not add track info.'
      end
    }
    redirect_to @project, notice: 'Track info successfully added.'
  end

  # DELETE /tracks/1
  def destroy
    @project = Project.find Project.decode_id(params[:project])
    authorize_action_for @project

    track = Track.find(params[:id])
    track.destroy
    redirect_to project_path(params[:project]), notice: 'Track was successfully deleted.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find Project.decode_id(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def track_params
      params.require(:track).permit(:start, :end, :comment)
    end

    def track_params_upload
      params.require(:track).permit(:label, :comment)
    end

    def set_track_project
      @project = Project.find Project.decode_id(params[:project_id])
      @track = @project.tracks.where(user_id: current_user.id).order(created_at: :desc).first
      @track = @project.tracks.build if @track == nil || @track.status == 'uploaded'
    end

    def set_track
      @track = @project.tracks.where(user_id: current_user.id).order(created_at: :desc).first
      @track = @project.tracks.build if @track == nil || @track.status == 'uploaded'
    end

end
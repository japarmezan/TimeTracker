# Labels controller
class LabelsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_label, only: [:show, :edit, :update, :destroy]
  before_action :set_project, only: [:index, :new, :create]

  # GET /categories
  # GET /categories.json
  def index
    @labels = @project.labels
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
  end

  # GET /categories/new
  def new
    @label = @project.labels.build
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories
  # POST /categories.json
  def create
    @label = @project.labels.build(label_params)
    respond_to do |format|
      if @label.save
        format.html { redirect_to project_labels_path(@project), notice: 'Label was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    @project = Project.find(@label.project_id)
    respond_to do |format|
      if @label.update(label_params)
        format.html { redirect_to project_labels_path(@project), notice: 'Label was successfully updated.' }
        format.json { render :show, status: :ok, location: @label }
      else
        format.html { render :edit }
        format.json { render json: @label.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @label.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Label was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_label
    @label = Label.find Label.decode_id(params[:id])
  end

  def set_project
    @project = Project.find Project.decode_id(params[:project_id])
  end

  def label_params
    params.require(:label).permit(:name, :wage, :color)
  end
end

class ImportsController < ApplicationController
  before_action :set_import, only: %i[ show edit update destroy ]

  # GET /imports or /imports.json
  def index
    if logged_in? 
      @imports = current_user.imports
    end
  end

  # GET /imports/1 or /imports/1.json
  def show
  end

  # GET /imports/new
  def new
    @import = Import.new
  end

  # GET /imports/1/edit
  def edit
  end

  # POST /imports or /imports.json
  def create
    @import = Import.new(import_params)
    @import.status = "on hold"
    @import.user = current_user

    respond_to do |format|
      if @import.save
        format.html { redirect_to @import, notice: "Import was successfully created." }
        format.json { render :show, file: :created, location: @import }
      else
        format.html { render :new, file: :unprocessable_entity }
        format.json { render json: @import.errors, file: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /imports/1 or /imports/1.json
  def update
    respond_to do |format|
      if @import.update(import_params)
        format.html { redirect_to @import, notice: "Import was successfully updated." }
        format.json { render :show, file: :ok, location: @import }
      else
        format.html { render :edit, file: :unprocessable_entity }
        format.json { render json: @import.errors, file: :unprocessable_entity }
      end
    end
  end

  # DELETE /imports/1 or /imports/1.json
  def destroy
    @import.destroy
    respond_to do |format|
      format.html { redirect_to imports_url, notice: "Import was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_import
      @import = Import.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def import_params
      params.require(:import).permit(:file)
    end
end

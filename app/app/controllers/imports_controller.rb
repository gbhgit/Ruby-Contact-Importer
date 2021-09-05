class ImportsController < ApplicationController
  before_action :require_user, :set_import, only: %i[ show ]

  def index
    if logged_in? 
      @imports = current_user.imports
    else
      redirect_to login_path
    end
  end

  def show
    if !current_user.imports.find_by(id: params[:id])
      flash.now[:alert] = "Current user can't access this route."
      redirect_to root_path
    end
  end

  def new
    @import = Import.new
  end

  # POST /imports or /imports.json
  def create
    @import = Import.new(import_params)
    @import.status = "on hold"
    @import.user = current_user
    
    unless @import.header
      flash.now[:notice] = "Missing Header"
      redirect_to root_path
      return
    end

    respond_to do |format|
      if @import.save
        ProcessCsvJob.perform_later({id: @import.id, header: @import.header})
        flash[:notice] = "Import was successfully created."
        redirect_to root_path
        return
      else
        flash.now[:notice] = "Something went wrong"
        redirect_to root_path
        return
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_import
      @import = Import.find_by(id: params[:id])
    end

    # Only allow a list of trusted parameters through.
    def import_params
      params.require(:import).permit(:file, 
        header: [
          :name,
          :birthdate,
          :phone,
          :address,
          :credit_card,
          :email
        ]
      )
    end
end

# frozen_string_literal: true

class ImportsController < ApplicationController
  before_action :require_user, :set_import, only: %i[show]

  def index
    if logged?
      @imports = current_user.imports
    else
      redirect_to login_path
    end
  end

  def show
    unless current_user.imports.find_by(id: params[:id])
      flash[:alert] = "Current user can't access that route."
      redirect_to root_path
    end
  end

  def new
    @import = Import.new
  end

  def create
    @import = Import.new(import_params)
    @import.status = 'on hold'
    @import.user = current_user

    unless @import.header
      flash[:alert] = 'Header not found'
      redirect_to root_path
      return
    end

    respond_to do |_format|
      if @import.save
        ProcessCsvJob.perform_later({ id: @import.id, header: @import.header })
        flash[:notice] = 'Import was successfully saved.'
        redirect_to root_path
        return
      else
        flash[:alert] = 'Something went wrong, verify to upload the text file'
        redirect_to root_path
        return
      end
    end
  end

  private

  def set_import
    @import = Import.find_by(id: params[:id])
  end

  def import_params
    params.require(:import).permit(:file,
                                   header: %i[
                                     name
                                     birthdate
                                     phone
                                     address
                                     credit_card
                                     email
                                   ])
  end
end

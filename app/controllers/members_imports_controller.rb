class MembersImportsController < ApplicationController
  def new
    byebug
    @members_import = MembersImport.new
  end

  def create
    @members_import = MembersImport.new(params[:members_import])
    byebug
    if @members_import.save
      redirect_to members_path
    else
      render :new
    end
  end
end

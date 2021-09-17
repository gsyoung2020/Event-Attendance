# frozen_string_literal: true

class MembersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :catch_not_found
  before_action :set_member, only: %i[show edit update destroy]
  layout 'event_layout'

  # GET /members
  # GET /members.json
  def index
    @members = Member.all
    respond_to do |format|
      format.xlsx {
        response.headers[
          'Content-Disposition'
        ] = "attachment; filename=members.xlsx"
      }
      format.html { render :index }
    end
  end

  # GET /members/1
  # GET /members/1.json
  def show; end

  # GET /members/new
  def new
    @member = Member.new
  end

  # GET /members/:id/edit
  def edit; end

  # POST /members
  # POST /members.json
  def create
    @member = Member.new(member_params)
    if @member.save
      flash.notice = 'The member record was created successfully.'
      redirect_to @member
    else
      flash.now.alert = @member.errors.full_messages.to_sentence
      render :new
    end
  end

  # PATCH/PUT /members/id
  # PATCH/PUT /members/1.json
  def update
    if @member.update(member_params)
      flash.notice = 'The member record was updated successfully.'
      redirect_to @member
    else
      flash.now.alert = @member.errors.full_messages.to_sentence
      render :edit
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.json
  def destroy
    @member.destroy
    respond_to do |format|
      format.html { redirect_to members_url, notice: 'Member was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def upload
  end









  private

  # Use callbacks to share common setup or constraints between actions.
  def set_member
    @member = Member.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def member_params
    params.require(:member).permit(:first_name, :last_name, :phone, :birthday, :anniversary)
  end

  def catch_not_found(e)
    Rails.logger.debug('We had a not found exception.')
    flash.alert = e.to_s
    redirect_to members_path
  end
end
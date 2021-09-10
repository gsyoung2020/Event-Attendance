# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def after_sign_in_path_for(_resource)
    events_path # your path
  end

  def require_user
    # depending on your auth, something like...
    redirect_to root_path unless current_user
  end
end

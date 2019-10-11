# frozen_string_literal: true

class Admin::SessionsController < Devise::SessionsController
  include Accessible
  layout 'admins'
  skip_before_action :check_user, only: :destroy
  before_action :set_cache_headers

  def new
    super
  end

  def create
    super
  end

  def destroy
    super
  end

  protected

  def set_cache_headers
    response.headers["Cache-Control"] = "no-cache, no-store"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = (DateTime.now - 1.day)
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end

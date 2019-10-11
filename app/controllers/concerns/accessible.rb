module Accessible
  extend ActiveSupport::Concern
  included do
    before_action :check_user
  end

  protected

  def check_user
    if current_admin
      flash.clear
      redirect_to(rails_admin.dashboard_path) && return
    elsif current_user
      flash.clear
      redirect_to(additional_information_carts_path) && return
    end
  end
end

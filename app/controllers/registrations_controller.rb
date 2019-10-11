# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  private

  def sign_up_params
    params.require(:user).permit(:nome, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:nome, :telefone, :email, :password, :password_confirmation, :current_password)
  end

  protected

  def update_resource(resource, params)
    if params[:password].present?
      resource.update_with_password(params)
    else
      params.delete(:current_password)
      resource.update_without_password(params)
    end
  end

  def after_update_path_for(_resource)
    edit_user_registration_path
  end

  def after_sign_in_path_for(_resource)
    additional_information_carts_path
  end

  def after_sign_up_path_for(_resource)
    additional_information_carts_path
  end

  def after_sign_out_path_for(_resource)
    root_path
  end
end

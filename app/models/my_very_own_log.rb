class MyVeryOwnLog < ApplicationRecord

  scope :check_btms, -> { where(authoring_method: 'check_btms') }
  scope :handle_btms_temp_reservations, -> { where(authoring_method: 'handle_btms_temp_reservations') }
  scope :post_to_wsbtms, -> { where(authoring_method: 'post_to_wsbtms') }
  scope :run_payment, -> { where(authoring_method: 'run_payment') }
  scope :cielo_wrapper, -> { where(authoring_class: 'CieloWrapper') }

  rails_admin do
    list do
      scopes [:all, :check_btms, :handle_btms_temp_reservations, :post_to_wsbtms, :run_payment, :cielo_wrapper]
      include_fields :id, :info
    end
    show do
      include_fields :id, :authoring_class, :authoring_method, :authoring_user_email, :info
    end
  end
end

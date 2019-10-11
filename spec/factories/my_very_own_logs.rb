# frozen_string_literal: true

FactoryBot.define do
  factory :my_very_own_log do
    authoring_class      { 'Classy Class' }
    authoring_method     { 'Methodical Method' }
    authoring_user_email { 'user@e-mail.com' }
    info                 { 'Important info' }
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    name                { 'Event Conference' }
    number_participants { 300 }
    start_date          { '2018-07-17' }
    end_date            { '2018-07-18' }
    banner_img          { 'banner.png' }
  end
end

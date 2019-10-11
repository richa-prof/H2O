# frozen_string_literal: true

FactoryBot.define do
  factory :banner_locale do
    locale      { 'en-US' }
    titulo      { 'Something Exciting' }
    subtitulo   { 'Have fun!' }
    texto       { 'All the fun you could possibly wish for' }
    link        { 'this-banner-link' }
    association :banner
  end
end

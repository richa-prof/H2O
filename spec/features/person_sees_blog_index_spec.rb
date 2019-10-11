# frozen_string_literal: true

require 'rails_helper'

feature 'person sees blog index' do
  scenario 'sucessfully' do
    visit '/'
    click_on 'Blog H2O'

    expect(page).to have_content '23/10/2018'
    expect(page).to have_content 'This Blog Post'
    expect(page).to have_css("img[src*='this.blog.post.com.tif']")

    expect(page).to have_content '24/10/2018'
    expect(page).to have_content 'Second Post'
    expect(page).to have_css("img[src*='second.post.com.tif']")

    expect(page).to have_content 'Outros artigos que valem a pena:'
    expect(page).to have_content 'This is a listed post'
    expect(page).to have_content 'This is another listed post'
  end
end

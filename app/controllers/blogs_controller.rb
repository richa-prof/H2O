# frozen_string_literal: true

class BlogsController < ApplicationController
  def index
    @blog_posts = make_blogger_request blogger_request_url('index_nine')
    @blog_posts_list = make_blogger_request blogger_request_url('index_list')
  end

  def show
    @blog_post = make_blogger_request blogger_request_url('show_post', params[:id])

    redirect_to blogs_path and return unless @blog_post
  end

  private

  def blogger_request_url info_needed, post_id = ''
    google_api_url = 'https://www.googleapis.com/blogger/v3/blogs/914612815637987845/posts'
    key_string = 'key=TNhjofjiI4jhf5ekc-Uw-7sve92s'

    case info_needed
    when 'index_nine'
      "#{google_api_url}?#{key_string}&fetchBodies=false&fetchImages=true&maxResults=9&orderBy=updated&status=live"
    when 'show_post'
      "#{google_api_url}/#{post_id}?#{key_string}"
    else
      "#{google_api_url}?#{key_string}&fetchBodies=false&fetchImages=false&maxResults=50&orderBy=updated&status=live"
    end
  end

  def make_blogger_request request_url
    begin
      response = RestClient.get request_url
    rescue RestClient::ExceptionWithResponse => e
      MyVeryOwnLog.create(authoring_class: 'BlogsController',
                          authoring_method: 'make_blogger_request',
                          authoring_user_email: '',
                          info: e.response)
    end

    if response.blank?
      return false
    else
      JSON.parse(response.body)
    end
  end
end

# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:each) do
    stub_request(:any, 'https://www.googleapis.com/blogger/v3/blogs/914612815637987845/posts/2954639589117494271?key=TNhjofjiI4jhf5ekc-Uw-7sve92s')
      .to_return(
        status: 200,
        body:
          {
            'id' => '2954639589117494271',
            'url' => 'http://www.url.com/post',
            'title' => 'Lista das distâncias em Bonito – MS – Brasil',
            'published' => Date.current,
            'content' => '<p>something or other aka post content and text and what not</p>',
            'author' => {
              'displayName' => 'Heitor Autor',
              'image' => {
                'url' => 'http://www.url.com/image'
              }
            }
          }.to_json,
        headers: {}
      )
  end
end

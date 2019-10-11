# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:each) do
    stub_request(:any, 'https://www.googleapis.com/blogger/v3/blogs/914612815637987845/posts?fetchBodies=false&fetchImages=true&key=TNhjofjiI4jhf5ekc-Uw-7sve92s&maxResults=9&orderBy=updated&status=live')
      .to_return(
        status: 200,
        body:
          { "kind" => "blogger#postList",
            "nextPageToken" => "AAABBBCCC",
            "items" => [
              { "kind" => "blogger#post",
                "id" => "19031982",
                "blog" => { "id" => "914612815637987845" },
                "published" => "2018-10-23T12:44:00-07:00",
                "updated" => "2018-12-15T18:56:23-08:00",
                "etag" => "XYZ",
                "url" => "http://h2oecoturismo.blogspot.com/2018/10/bonitoms-entra-na-rota-do-turismo-de.html",
                "selfLink" => "www.this.blog.post.com",
                "title" => "This Blog Post",
                "images" => [
                  { "url" => "https://img.this.blog.post.com.tif" }
                ],
                "author" => {
                  "displayName" => "My Name Is Slim Shady",
                  "image" => {
                    "url" => "img.blogblog.com/img/shady.gif"
                  }
                },
                "replies" => {
                  "totalItems" => "0",
                  "selfLink" => "www.this.blog.post.com/comments"
                }
              },
              { "kind" => "blogger#post",
                "id" => "14051984",
                "blog" => { "id" => "914612815637987845" },
                "published" => "2018-10-24T12:44:00-07:00",
                "updated" => "2018-12-20T18:56:23-08:00",
                "etag" => "XYZ",
                "url" => "http://h2oecoturismo.blogspot.com/2018/10/lalala.html",
                "selfLink" => "www.second.post.com",
                "title" => "Second Post",
                "images" => [
                  { "url" => "https://img.second.post.com.tif" }
                ],
                "author" => {
                  "displayName" => "My Name Is Slim Shady",
                  "image" => {
                    "url" => "img.blogblog.com/img/shady.gif"
                  }
                },
                "replies" => {
                  "totalItems" => "0",
                  "selfLink" => "www.this.blog.post.com/comments"
                }
              }
            ],
            "etag" => "iHf3yWDE_geBgZ8U7rgZ_xuTeAQ/MjAxOC0xMi0yMVQwMjo1NjoyMy41MjZa"
          }.to_json,
        headers: {}
      )

    stub_request(:any, 'https://www.googleapis.com/blogger/v3/blogs/914612815637987845/posts?fetchBodies=false&fetchImages=false&key=TNhjofjiI4jhf5ekc-Uw-7sve92s&maxResults=50&orderBy=updated&status=live')
      .to_return(
        status: 200,
        body:
          { "kind" => "blogger#postList",
            "nextPageToken" => "AAABBBCCC",
            "items" => [
              { "kind" => "blogger#post",
                "id" => "19031982",
                "blog" => { "id" => "914612815637987845" },
                "published" => "2018-10-23T12:44:00-07:00",
                "updated" => "2018-12-15T18:56:23-08:00",
                "etag" => "XYZ",
                "url" => "http://h2oecoturismo.blogspot.com/2018/10/bonitoms-entra-na-rota-do-turismo-de.html",
                "selfLink" => "www.this.blog.post.com",
                "title" => "This is a listed post",
                "images" => [
                  { "url" => "https://img.this.blog.post.com.tif" }
                ],
                "author" => {
                  "displayName" => "My Name Is Slim Shady",
                  "image" => {
                    "url" => "img.blogblog.com/img/shady.gif"
                  }
                },
                "replies" => {
                  "totalItems" => "0",
                  "selfLink" => "www.this.blog.post.com/comments"
                }
              },
              { "kind" => "blogger#post",
                "id" => "14051984",
                "blog" => { "id" => "914612815637987845" },
                "published" => "2018-10-24T12:44:00-07:00",
                "updated" => "2018-12-20T18:56:23-08:00",
                "etag" => "XYZ",
                "url" => "http://h2oecoturismo.blogspot.com/2018/10/lalala.html",
                "selfLink" => "www.second.post.com",
                "title" => "This is another listed post",
                "images" => [
                  { "url" => "https://img.second.post.com.tif" }
                ],
                "author" => {
                  "displayName" => "My Name Is Slim Shady",
                  "image" => {
                    "url" => "img.blogblog.com/img/shady.gif"
                  }
                },
                "replies" => {
                  "totalItems" => "0",
                  "selfLink" => "www.this.blog.post.com/comments"
                }
              }
            ],
            "etag" => "iHf3yWDE_geBgZ8U7rgZ_xuTeAQ/MjAxOC0xMi0yMVQwMjo1NjoyMy41MjZa"
          }.to_json,
        headers: {}
      )
  end
end

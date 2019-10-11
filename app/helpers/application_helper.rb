# frozen_string_literal: true

module ApplicationHelper
  def link_to_add_row(name, f, association, **args)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize, f: builder)
    end
    link_to(name, '#', class: 'add_fields' + args[:class], data: { id: id, fields: fields.delete("\n") })
  end

  def link_to_blog_post locale, blogger_id, blogger_url
    "/#{locale.downcase}/blog/#{blogger_id}/#{(blogger_url.chomp(".html")).split('/')[-1]}"
  end

  def touristType_array
    if params[:locale] == 'en-US'
      [
        "nature tourism",
        "photography tourism",
        "adventure tourism",
        "safe tourism",
        "ecotourism",
        "sustainable tourism",
        "socially responsible tourism",
        "tourism for families"
      ]
    else
      [
        "turismo de natureza",
        "turismo para fotografia",
        "turismo de aventura",
        "turismo seguro",
        "ecoturismo",
        "turismo sustentável",
        "turismo responsável",
        "turismo para famílias"
      ]
    end
  end
end

def rails_admin_select option_to_select, field_id
  within "div##{field_id}" do
    find('span.input-group-btn').click
  end
  find('a.ui-menu-item-wrapper', text: option_to_select).click
end

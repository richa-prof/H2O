# frozen_string_literal: true

module MetaTagsHelper
  def meta_description
    content_for?(:meta_description) ? content_for(:meta_description) : DEFAULT_META['meta_description']
  end
end

require 'nokogiri'
require 'action_view'

ActionView::Helpers::AssetTagHelper.module_eval do
  alias :rails_image_tag :image_tag

  def image_tag(*attrs)
    options, args = extract_options_and_args(*attrs)
    image_html = rails_image_tag(*args)
    img = Nokogiri::HTML::DocumentFragment.parse(image_html).at_css('img')

    if Rails.env.development? && img['src'].include?('/images/')
      img['src'] = asset_path('agencia-h2o-apaixone-se-dev.png')
    end

    img['alt'] = alt_title img['src'] if img['alt'].blank?
    img['title'] = alt_title img['src'] if img['title'].blank?

    if options.key?(:lazy) && options[:lazy] == true
      img['data-src'] = img['src']
      img['src'] = asset_path('agencia-h2o-apaixone-se.png')
    end

    img.to_s.html_safe
  end

  private

  def alt_title image_src
    return 'Agência H2O - Bonito MS' if image_src.blank?
    image_src.split('/')[-1].rpartition('.').first
  end

  def extract_options_and_args(*attrs)
    args = attrs

    if args.size > 1
      options = attrs.last.dup
      args.last.delete(:lazy)
    else
      options = {}
    end

    [options, args]
  end
end

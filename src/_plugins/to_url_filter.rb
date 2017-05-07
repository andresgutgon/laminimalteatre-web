module Jekyll
  # Get full page url localized
  module ToUrlFilter
    # @param [Hash] page
    # @param [String] base_path
    # @param [String] path
    # @param [String] localized
    def to_url(page, base_path, path = nil)
      site = @context.registers[:site]
      domain_url = site.config['url']
      localized_path = get_localized_path(page, base_path)
      url = "#{domain_url}/#{localized_path}"

      return url if path.nil?

      "#{url}/#{path}"
    end

    private

    def get_localized_path(page, base_path)
      return base_path if base_path == 'blog'

      site = @context.registers[:site]
      language = page['language']
      menu = site.data['menu']
      menu_path = menu[base_path][language]

      return menu_path if base_path == 'root'
      "#{language}/#{menu_path}"
    end
  end
end

Liquid::Template.register_filter(Jekyll::ToUrlFilter)

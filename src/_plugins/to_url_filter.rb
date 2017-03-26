module Jekyll
  # Get full page url localized
  module ToUrlFilter
    # @param [Hash] page
    # @param [String] base_path
    # @param [String] path
    # @param [String] hash
    def to_url(page, base_path, path = nil, hash = nil)
      hash_string = hash ? "##{hash}" : ''
      language = page['language']
      site = @context.registers[:site]
      domain_url = site.config['url']
      menu = site.data['menu']
      url = "#{domain_url}/#{menu[base_path][language]}"

      return "#{url}#{hash_string}" if path.nil?

      "#{url}/#{path}#{hash_string}"
    end
  end
end

Liquid::Template.register_filter(Jekyll::ToUrlFilter)

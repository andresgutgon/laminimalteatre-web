module Jekyll
  # Get full page url localized
  module LanguageUrls
    # @param [Hash] page
    def language_urls(page)
      permalinks = page['permalinks']
      current_locale = page['language']

      return get_default_language(current_locale) unless permalinks
      permalinks
    end

    private

    def get_default_language(locale)
      @context
        .registers[:site]
        .config['languages']
        .reject { |loc| loc == locale }
        .map do |language|
          {
            'locale' => language,
            'url' => "#{language}/"
          }
        end
    end
  end
end

Liquid::Template.register_filter(Jekyll::LanguageUrls)

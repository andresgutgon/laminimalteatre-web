module Jekyll
  # Get full page url localized
  module LanguageUrls
    # @param [Hash] page
    def canonical_urls(page)
      permalinks = page['permalinks']
      current_locale = page['language']

      return get_default_language(current_locale) if home?(page)
      return  [] unless permalinks
      permalinks
    end

    # @param [Hash] page
    def language_urls(page)
      permalinks = page['permalinks']
      current_locale = page['language']

      return get_default_language(current_locale) if home?(page)
      return get_non_localized_urls(current_locale, page) unless permalinks
      permalinks
    end

    private

    def home?(page)
      page['layout'] == 'home'
    end

    def get_non_localized_urls(locale, page)
      @context
        .registers[:site]
        .config['languages']
        .reject { |loc| loc == locale }
        .map do |language|
          {
            'locale' => language,
            'url' => page['permalink']
          }
        end
    end

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

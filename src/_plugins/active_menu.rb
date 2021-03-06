module Jekyll
  # Get full page url localized
  module ActiveMenu
    MENU_REGEX = %r{^\w+\/([\-0-9A-Za-z]*)\/?.*$}
    # @param [Hash] page
    # @param [String] menu_item
    # @param [String] base_class
    def active_menu(page, menu_item, base_class)
      permalink = page['permalink']
      return nil if permalink.nil?
      match = MENU_REGEX.match(permalink)
      return nil if match.nil?

      current = match[1]
      site = @context.registers[:site]
      menu = site.data['menu']
      menu_item_localized = menu[menu_item].values

      return nil unless menu_item_localized.include? current

      "#{base_class}--active"
    end
  end
end

Liquid::Template.register_filter(Jekyll::ActiveMenu)

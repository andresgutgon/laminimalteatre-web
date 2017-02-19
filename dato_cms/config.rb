require 'byebug'
# dato.available_locales.each do |locale|
#   directory 'content/#{locale}' do
#     I18n.with_locale(locale) do
#       create_data_file 'site.yml', :yaml, dato.site.to_hash
#       dato.item_types.each do |item_type|
#         create_data_file '#{item_type.api_key}.yml', :yaml, 
#                          dato.items_of_type(item_type).map(&:to_hash)
#       end
#     end
#   end
# end

I18n.available_locales.each do |locale|
  directory "src/_content/_teams/#{locale}" do
    I18n.with_locale(locale) do
      dato.teams.each do |team|
        create_post "#{team.slug}.md" do
          frontmatter(
            :yaml,
            layout: 'team',
            name: team.name,
            languages: I18n.available_locales,
            language: locale
          )
        end
      end
    end
  end
end

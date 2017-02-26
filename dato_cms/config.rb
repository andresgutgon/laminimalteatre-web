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
  languages = I18n.available_locales.map { |l| l.to_s }

  directory "src/home/#{locale.to_s}" do
    I18n.with_locale(locale) do
      create_post 'index.md' do
        frontmatter(
          :yaml,
          layout: 'home',
          languages: languages,
          current_locale: locale.to_s,
          image_url: dato.home.home_image.file.width(800).to_url,
          intro_text: dato.home.intro_text,
          permalink: "#{locale}/"
        )
      end
    end
  end

  dato.teams.each do |team|
    directory "src/teams/#{locale.to_s}/#{team.slug}" do
      I18n.with_locale(locale) do
        create_post 'index.md' do
          frontmatter(
            :yaml,
            layout: 'page',
            name: team.name,
            languages: languages,
            current_locale: locale.to_s,
            permalink: "#{locale.to_s}/teams/#{team.slug}"
          )
        end
      end
    end
  end
end


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

directory "src/_teams" do
  I18n.available_locales.each do |locale|
    I18n.with_locale(locale) do
      dato.teams.each do |team|
        create_post "#{locale.to_s}_#{team.slug}.yaml" do
          frontmatter :yaml,
                      name: team.name,
                      locale: locale.to_s,
                      db_id: team.id
        end
      end
    end
  end
end

directory "src/_members" do
  I18n.available_locales.each do |locale|
    I18n.with_locale(locale) do
      dato.teams.each do |team|
        team.team_items.each do |member|
          user = member.user
          create_post "#{locale.to_s}_#{team.slug}_#{user.slug}.yaml" do
            frontmatter :yaml,
                        full_name: "#{user.name} #{user.surname}",
                        team_db_id: team.id,
                        locale: locale.to_s,
                        avatar: user.avatar.file.width(120).to_url,
                        role: member.role,
                        bio: user.bio
          end
        end
      end
    end
  end
end


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
end


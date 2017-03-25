require 'byebug'

def slug_url(slug:, locale:)
  "#{locale.to_s}/#{SHOW_ROOT[locale]}/#{slug}"
end

def slug_url_with_index(slug)
  "#{slug_url(slug)}/index.html"
end

def field_in_all_locales(record, field_name, current_locale)
  I18n
    .available_locales
    .reject { |locale| locale == current_locale }
    .map do |locale|
      I18n.with_locale(locale) do
        {
          slug: record.send(field_name),
          locale: locale
        }
      end
    end
end

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
            position: team.position,
            slug: team.slug,
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
              position: member.position,
              bio: user.bio
          end
        end
      end
    end
  end
end

SHOW_ROOT  = {
  es: 'espectaculos',
  ca: 'espectacles',
  en: 'shows'
}

directory "src/shows" do
  I18n.available_locales.each do |locale|
    I18n.with_locale(locale) do
      dato.plays.each do |play|
        slugs = field_in_all_locales(play, :slug, locale)
        permalinks = slugs.map do |slug|
          {
            url: slug_url(slug),
            locale: slug[:locale].to_s
          }
        end
        permalink = slug_url_with_index({ slug: play.slug, locale: locale })
        create_post "#{locale.to_s}_#{play.slug}.yaml" do
          galery = play.galery.map do |item|
            {
              image_url: item.file.width(800).to_url,
              image_thumbnail_url: item.file.width(220).to_url,
              title: item.title
            }
          end
          frontmatter :yaml,
            layout: 'show',
            title: play.title,
            language: locale.to_s,
            galery: galery,
            permalinks: permalinks,
            permalink: permalink
        end
      end
    end
  end
end

I18n.available_locales.each do |locale|
  # languages = I18n.available_locales.map { |l| l.to_s }

  directory "src/home/#{locale.to_s}" do
    I18n.with_locale(locale) do
      create_post 'index.md' do
        frontmatter(
          :yaml,
          layout: 'home',
          language: locale.to_s,
          image_url: dato.home.home_image.file.width(800).to_url,
          intro_text: dato.home.intro_text,
          subset: 'home',
          permalink: "#{locale}/"
        )
      end
    end
  end
end

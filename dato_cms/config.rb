require 'byebug'

MAIN_MENU  = {
  root: {
    es: 'es',
    ca: 'ca',
    en: 'en'
  },
  show: {
    es: 'espectaculos',
    ca: 'espectacles',
    en: 'shows'
  },
  story: {
    es: 'nuestra-historia',
    ca: 'la-nostra-historia',
    en: 'our-story'
  },
  team: {
    es: 'equipo',
    ca: 'equip',
    en: 'team'
  },
  gallery: {
    es: 'galeria',
    ca: 'galeria',
    en: 'gallery'
  },
  blog: {
    es: 'blog',
    ca: 'blog',
    en: 'blog'
  }
}

PLAY_CAST = %w(
  direction_and_arts
  sound
  music
  singers
  scenography
  makeup
  lighting
  costum_design
  assistant_director
).freeze

def full_name(person)
  "#{person.name} #{person.surname}"
end

def play_directed_by(play)
  play.direction_and_arts
    .map do |person|
      attr = person.attributes
      "#{attr[:name]} #{attr[:surname]}"
    end
    .join(', ')
end

def play_cast(play)
  PLAY_CAST.reduce([]) do |memo, cast_item|
    begin
      cast = play.send(cast_item)
      return memo unless cast.present?
      memo << {
        key: cast_item,
        members: cast.map { |member| full_name(member) }.join(', ')
      }
      memo
    rescue StandardError => error
      print "Error getting cast field: #{error}"
    end
  end
end

def play_actors(actors)
  actors
  .sort! { |x, y| x.name <=> y.name }
  .map do |actor|
    {
      name: full_name(actor),
      avatar_url: actor.avatar.file.width(100).to_url
    }
  end
end

def menu_root(item, locale)
  MAIN_MENU[item][locale.to_sym]
end

def slug_url(slug:, locale:)
  "#{locale.to_s}/#{menu_root(:show, locale)}/#{slug}"
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

def get_permalinks(record, field_name, locale)
  field_in_all_locales(record, field_name, locale)
    .map do |slug|
      {
        url: slug_url(slug),
        locale: slug[:locale].to_s
      }
    end
end

def get_permalinks_for_index(root, current_locale)
  I18n.available_locales
      .reject { |locale| locale == current_locale }
      .map do |locale|
        {
          url: "#{locale.to_s}/#{menu_root(root, locale)}",
          locale: locale.to_s
        }
      end
end

create_data_file('src/_data/social_links.yml',
  :yaml,
  dato.social_profiles.map do |social|
    {
      url: social.url,
      position: social.position,
      type: social.profile_type,
      icon_template: "icons/#{social.profile_type}.html"
    }
  end
)
create_data_file('src/_data/menu.yml', :yaml, MAIN_MENU)
create_data_file('src/_data/menu_items.yml',
  :yaml,
  MAIN_MENU.keys
    .reject { |key| key == :root }
    .map do |item|
      {
        i18n: "main_menu.#{item}",
        key: item.to_s
      }
    end
)

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

directory "src/_shows" do
  I18n.available_locales.each do |locale|
    I18n.with_locale(locale) do
      dato.plays.each do |play|
        permalink = slug_url({ slug: play.slug, locale: locale })
        directed_by = play_directed_by(play)
        create_post "#{locale.to_s}_#{play.slug}.yaml" do
          frontmatter :yaml,
            locale: locale.to_s,
            image: play.teaser.thumbnail_url,
            directed_by: directed_by,
            permalink: permalink,
            slug: play.slug,
            position: play.position,
            title: play.title
        end
      end
    end
  end
end

I18n.available_locales.each do |locale|
  # Home
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

  # Team
  directory "src/team/#{locale.to_s}" do
    I18n.with_locale(locale) do
      slug = menu_root(:team, locale)
      create_post 'index.md' do
        frontmatter(
          :yaml,
          layout: 'team',
          language: locale.to_s,
          permalink: "#{locale}/#{slug}/index.html"
        )
      end
    end
  end

  # Story
  directory "src/story/#{locale.to_s}" do
    I18n.with_locale(locale) do
      slug = menu_root(:story, locale)
      create_post 'index.md' do
        frontmatter(
          :yaml,
          layout: 'story',
          language: locale.to_s,
          intro_text: dato.home.intro_text,
          permalink: "#{locale}/#{slug}/index.html"
        )
      end
    end
  end

  # Shows
  directory "src/shows/#{locale.to_s}" do
    I18n.with_locale(locale) do
      # Shows list
      permalinks = get_permalinks_for_index(:show, locale)
      permalink = "#{locale}/#{menu_root(:show, locale)}/index.html"
      create_post 'index.md' do
        frontmatter(
          :yaml,
          layout: 'shows_list',
          language: locale.to_s,
          permalinks: permalinks,
          permalink: permalink
        )
      end
      # Show detail
      dato.plays.each do |play|
        actors = play_actors(play.actors)
        cast = play_cast(play)
        permalinks = get_permalinks(play, :slug, locale)
        permalink = slug_url_with_index({ slug: play.slug, locale: locale })
        directed_by = play_directed_by(play)
        create_post "#{play.slug}.yaml" do
          video_id = play.teaser.provider_uid
          teaser = {
            video_id: video_id,
            url: play.teaser.url,
            player_url: "https://player.vimeo.com/video/#{video_id}",
            thumbnail_url: play.teaser.thumbnail_url,
            width: play.teaser.width,
            height: play.teaser.height,
            title: play.teaser.title
          }
          gallery = play.gallery.map do |item|
            {
              url: item.file.width(800).to_url,
              thumbnail_url: item.file.width(100).to_url,
              title: item.title
            }
          end
          frontmatter :yaml,
            layout: 'show',
            title: play.title,
            teaser: teaser,
            language: locale.to_s,
            gallery: gallery,
            permalinks: permalinks,
            permalink: permalink,
            directed_by: directed_by,
            actors: actors,
            cast: cast,
            synopsis: play.synopsis,
            subset: 'play',
            externalJsFiles: ['https://player.vimeo.com/api/player.js'],
            jsFiles: [
              'assets/js/vendor/jquery.gallery.min.js',
              'assets/js/pages/show.js'
            ]
        end
      end
    end
  end
end

# Read all the details about the commands available in this file here:
# https://github.com/datocms/ruby-datocms-client/blob/master/docs/dato-cli.md

# iterate over all the `social_profile` item types
social_profiles = dato.social_profiles.map do |profile|
  {
    url: profile.url,
    type: profile.profile_type.downcase.gsub(/ +/, '-'),
  }
end

# Create a YAML data file to store global data about the site
create_data_file "src/_data/settings.yml", :yaml,
  name: dato.site.global_seo.site_name,
  language: dato.site.locales.first,
  social_profiles: social_profiles,
  favicon_meta_tags: dato.site.favicon_meta_tags

# Create a markdown file with the SEO settings coming from the `home` item
# type stored in DatoCMS
# paginate: { collection: 'works', per_page: 5 }
create_post "src/index.md" do
  frontmatter(
    :yaml,
    language: 'en',
    seo_meta_tags: dato.home.seo_meta_tags,
    cover: dato.home.home_image.url(w: 800, fm: 'jpg', auto: 'compress'),
    intro: dato.home.intro_text,
    layout: 'home'
  )
end

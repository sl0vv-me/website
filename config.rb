# frozen_string_literal: true

set :css_dir,    'assets/stylesheets'
set :fonts_dir,  'assets/fonts'
set :images_dir, 'assets/images'
set :js_dir,     'assets/javascripts'

set :sass_assets_paths, %w[node_modules]

page '/*.xml',  layout: false
page '/*.json', layout: false
page '/*.txt',  layout: false

activate :i18n, mount_at_root: :ru

activate :autoprefixer do |prefix|
  prefix.browsers = 'last 2 versions'
end

helpers do
  def translate(*args)
    I18n.translate(*args)
  end

  def title
    if current_page.data.title
      "#{current_page.data.title} | #{translate(:title)}"
    else
      translate :title
    end
  end

  def description
    if current_page.data.description
      current_page.data.description
    else
      translate :description
    end
  end
end

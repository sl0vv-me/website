# frozen_string_literal: true

set :base_url, 'https://crypto-libertarian.com'

set(
  :external_links,
  telegram_channel: 'https://t.me/crypto_libertarian',
  telegram_chat: 'https://t.me/crypto_libertarian_chat',
  youtube_channel: 'https://www.youtube.com/channel/UCj9VPPL4riHinL3N9RbmLww',
  medium_blog: 'https://medium.com/crypto-libertarian',
  git: 'https://git.crypto-libertarian.com',
)

set :css_dir,    'assets/stylesheets'
set :fonts_dir,  'assets/fonts'
set :images_dir, 'assets/images'
set :js_dir,     'assets/javascripts'

set :sass_assets_paths, %w[node_modules]

page '/*.html', layout: 'layout.html'
page '/*.xml',  layout: false
page '/*.json', layout: false
page '/*.txt',  layout: false
page '/*.asc',  layout: false

activate :i18n, mount_at_root: :ru

activate :autoprefixer do |prefix|
  prefix.browsers = 'last 2 versions'
end

configure :build do
  activate :asset_host, host: config[:base_url]
end

webpack_command =
  if build?
    './node_modules/webpack/bin/webpack.js --bail -p'
  else
    './node_modules/webpack/bin/webpack.js --watch -d --progress --color'
  end

activate :external_pipeline,
         name: :webpack,
         command: webpack_command,
         source: 'dist/webpack',
         latency: 1

helpers do
  def translate(*args)
    I18n.translate(*args)
  end

  def base_url
    config[:base_url]
  end

  def canonical_url
    "#{base_url}#{current_page.url}"
  end

  def external_link(key)
    config[:external_links][key] or raise "Invalid key: #{key.inspect}"
  end

  def title
    if current_page.data.title
      "#{translate(current_page.data.title)} | #{translate(:title)}"
    else
      translate :title
    end
  end

  def description
    if current_page.data.description
      translate current_page.data.description
    else
      translate :description
    end
  end

  def active_class(url)
    return ' active ' if current_page.url == url
  end
end

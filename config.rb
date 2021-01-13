# frozen_string_literal: true

lib = File.expand_path('lib', __dir__).freeze
$LOAD_PATH.unshift lib unless $LOAD_PATH.include? lib

require 'middleman-blog/truncate_html'

module ::URI
  ##
  # Bug in Ruby 3.0.0
  #
  # undefined method `escape' for URI:Module
  # ~/.rvm/gems/ruby-3.0.0@crypto_libertarian-website/gems/middleman-core-4.3.11/lib/middleman-core/builder.rb:232:in `block in output_resource'
  #
  def self.escape(*args)
    DEFAULT_PARSER.escape(*args)
  end
end

WEBPACK_SCRIPT =
  File.expand_path('node_modules/webpack/bin/webpack.js', __dir__).freeze

WEBPACK_BUILD = "#{WEBPACK_SCRIPT} --bail -p"
WEBPACK_RUN   = "#{WEBPACK_SCRIPT} --watch -d --progress --color"

set :base_url, 'https://crypto-libertarian.com'

set(
  :external_links,
  telegram_channel: 'https://t.me/crypto_libertarian',
  telegram_chat: 'https://t.me/crypto_libertarian_chat',
  youtube_channel: 'https://www.youtube.com/channel/UCj9VPPL4riHinL3N9RbmLww',
  medium_blog: 'https://medium.com/crypto-libertarian',
)

set :css_dir,    'assets/stylesheets'
set :fonts_dir,  'assets/fonts'
set :images_dir, 'assets/images'
set :js_dir,     'assets/javascripts'

set :sass_assets_paths, %w[node_modules]

page '/*.xml',  layout: false
page '/*.json', layout: false
page '/*.txt',  layout: false
page '/*.asc',  layout: false

activate :i18n, mount_at_root: :ru

activate :autoprefixer do |prefix|
  prefix.browsers = 'last 2 versions'
end

activate :blog do |blog|
  blog.layout = 'blog_article'
  blog.prefix = '/blog'

  blog.summary_generator = lambda do |blog_article, text, max_length, ellipsis|
    max_length = 250 if max_length.nil?
    ellipsis_length = ellipsis.length
    text = text.encode('UTF-8') if text.respond_to?(:encode)
    doc = Nokogiri::HTML::DocumentFragment.parse text
    actual_length = max_length - ellipsis_length
    doc.truncate(actual_length, ellipsis).inner_text
  end
end

configure :build do
  activate :asset_host, host: config[:base_url]
end

activate :external_pipeline,
         name: :webpack,
         command: build? ? WEBPACK_BUILD : WEBPACK_RUN,
         source: File.expand_path('tmp/webpack', __dir__),
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
    if current_page.data.title.blank?
      translate :title
    else
      if current_page.data.title =~ /\A~(\w+)\z/
        "#{translate($1)} | #{translate(:title)}"
      else
        "#{current_page.data.title} | #{translate(:title)}"
      end
    end
  end

  def description
    if current_page.data.description.blank?
      translate :description
    else
      if current_page.data.description =~ /\A~(\w+)\z/
        translate $1
      else
        current_page.data.description
      end
    end
  end

  def active_class(*urls)
    return ' active ' if urls.any? { |url| active_class? url }
  end

  def active_class?(url)
    case url
    when String
      current_page.url == url
    when Regexp
      current_page.url.match? url
    else
      raise TypeError
    end
  end
end

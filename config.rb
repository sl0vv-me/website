# frozen_string_literal: true

configure :build do
  set :host, 'https://crypto-libertarian.com'
end

set :sass_assets_paths, %w[
  node_modules/bootstrap/scss
]

activate :i18n, mount_at_root: :ru

activate :autoprefixer do |prefix|
  prefix.browsers = 'last 2 versions'
end

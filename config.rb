# frozen_string_literal: true

set :sass_assets_paths, %w[node_modules]

activate :i18n, mount_at_root: :ru

activate :autoprefixer do |prefix|
  prefix.browsers = 'last 2 versions'
end

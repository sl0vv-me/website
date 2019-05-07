# frozen_string_literal: true

set :sass_assets_paths, %w[
  node_modules/bootstrap/scss
]

activate :i18n, mount_at_root: :ru

activate :autoprefixer do |prefix|
  prefix.browsers = 'last 2 versions'
end

helpers do
  def global_term_names(term)
    local_term_names term
  end

  def local_term_names(term)
    I18n.translate term, scope: %i[terms names], default: []
  end
end

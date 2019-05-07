# frozen_string_literal: true

set :sass_assets_paths, %w[
  node_modules/bootstrap/scss
]

activate :i18n, mount_at_root: :ru

activate :autoprefixer do |prefix|
  prefix.browsers = 'last 2 versions'
end

helpers do
  def term_link(term)
    link_to "glossary.html##{term}" do
      content_tag :small do
        "[#{I18n.translate(:link)}]"
      end
    end
  end

  def global_term_names(term)
    local_term_names(term).reverse.each_with_index.reverse_each
  end

  def local_term_names(term)
    I18n.translate term, scope: %i[terms names], default: []
  end

  def term_summary(term)
    I18n.translate term, scope: %i[terms summaries], default: nil
  end
end

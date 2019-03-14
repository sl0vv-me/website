# frozen_string_literal: true

activate :i18n, mount_at_root: :ru

activate :autoprefixer do |prefix|
  prefix.browsers = 'last 2 versions'
end

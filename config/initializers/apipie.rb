Apipie.configure do |config|
  config.app_name      = 'AlbinAuth'
  config.app_info      = 'An authorization app to be used in cross other apps.'
  config.api_base_url  = '/api'
  config.doc_base_url  = '/apipie'
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
end

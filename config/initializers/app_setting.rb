path = File.expand_path('../../app_settings.yml', __FILE__)
::AppSetting = RecursiveOpenStruct.new(YAML.load_file(path)[Rails.env])

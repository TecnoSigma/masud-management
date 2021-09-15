yaml_file  = File.read("#{Rails.root}/config/app_config.yml")
APP_CONFIG = YAML.load(yaml_file).deep_symbolize_keys

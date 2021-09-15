yaml_file  = File.read("#{Rails.root}/config/qrcode_config.yml")
QRCODE_CONFIG = YAML
               .load(yaml_file)
               .deep_symbolize_keys

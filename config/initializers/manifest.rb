yaml_file  = File.read("#{Rails.root}/config/manifest.yml")
MANIFEST_CONFIG = YAML.load(yaml_file).deep_symbolize_keys

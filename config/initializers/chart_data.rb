yaml_file = File.read("#{Rails.root}/config/chart_data.yml")
CHART_DATA = YAML.load(yaml_file).deep_symbolize_keys

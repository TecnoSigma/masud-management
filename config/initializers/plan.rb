yaml_file = File.read("#{Rails.root}/config/plans.yml")
PLAN_CONFIG = YAML.load(yaml_file).deep_symbolize_keys

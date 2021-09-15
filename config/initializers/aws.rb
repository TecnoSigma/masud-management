require 'aws-sdk'

Aws.config.update({
  region: ENV['AWS_REGION'],
  credentials: Aws::Credentials.new(ENV['AWS_KEY_ID'], ENV['AWS_ACCESS_KEY'])
})

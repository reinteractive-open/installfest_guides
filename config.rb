# Page config
page "/guides/*", :layout => "guides"

# Env Setup
set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

activate :directory_indexes

# Markdown

set :markdown_engine, :redcarpet
set :markdown, :fenced_code_blocks => true, :smartypants => true

# Code highlighting

activate :rouge_syntax

# Until fog can deal with a . in the bucket name without an SSL mismatch
# we need to host on Heroku
#
aws_creds = File.join(File.dirname(__FILE__), 'aws.yml')
creds = YAML::load_file(aws_creds)

activate :s3_sync do |s3_sync|
  s3_sync.bucket                     = creds['fog_directory'] # The name of the S3 bucket you are targetting. This is globally unique.
  s3_sync.region    = creds['fog_region']
  s3_sync.aws_access_key_id          = creds['aws_access_key_id']
  s3_sync.aws_secret_access_key      = creds['aws_secret_access_key']
  # s3_sync.delete                     = true # We delete stray files by default.
  s3_sync.after_build                = false # We chain after the build step by default. This may not be your desired behavior...
  s3_sync.path_style = true
  # s3_sync.verbose = true
  # s3_sync.prefer_gzip                = true
  # s3_sync.reduced_redundancy_storage = false
end

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end

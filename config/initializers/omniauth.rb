Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV["GITHUB_CLIENT_ID"], ENV["GITHUB_CLIENT_SECRET"], scope: "user:email"
end

OmniAuth.config.logger = Rails.logger

# NOTE: would need to access in a different way for
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"], {client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s}}}
end

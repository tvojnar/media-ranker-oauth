Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV["GITHUB_CLIENT_ID"], ENV["GITHUB_CLIENT_SECRET"], scope: "user:email"
end

OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '22716657647-02rohvue1su4mqd1i25j7sc47c74mm55.apps.googleusercontent.com', '5YJaEVQTJA6REH3x2xkHm1SJ', {client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s}}}
end

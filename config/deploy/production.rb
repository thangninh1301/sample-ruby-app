set :stage, :production
set :rails_env, :production
set :branch, "dplTask"
set :deploy_to, "/home/deploy/sample_app"
server "54.255.48.27", user: "deploy", roles: %w{app db web}


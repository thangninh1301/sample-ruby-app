set :stage, :production
set :rails_env, :production
set :branch, "dplTask"
set :deploy_to, "/home/deploy/sample_app"
server "13.229.49.52", user: "deploy", roles: %w{app db web}

set :stage, :production
set :rails_env, :production
set :branch, "dplTask"
set :deploy_to, "/home/deploy/sample_app"
server "13.212.249.86", user: "deploy", roles: %w{app db web}

set :stage, :production
set :rails_env, :production
set :branch, "dplTask"
set :deploy_to, "/home/deploy/sample_app"
server "54.255.48.27", user: "deploy", roles: %w{app db web}

set :application, "sample_app"
set :repo_url, "git@github.com:thangninh1301/sample_app.git"

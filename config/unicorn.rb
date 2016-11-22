app_dir = File.expand_path("../..", __FILE__)
working_directory app_dir

pid "#{app_dir}/tmp/unicorn.pid"

stderr_path "/dev/stderr"
stdout_path "/dev/stdout"

worker_processes 3
listen "/tmp/unicorn.sock", :backlog => 64
timeout 30

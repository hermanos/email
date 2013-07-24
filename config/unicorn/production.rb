APP_ROOT = ENV['PWD']

worker_processes 2
preload_app      true
user             'ubuntu', 'ubuntu'
timeout          30

working_directory APP_ROOT
listen            APP_ROOT + "/tmp/sockets/unicorn.sock", :backlog => 64
pid               APP_ROOT + "/tmp/pids/unicorn.pid"
stderr_path       APP_ROOT + "/log/unicorn.stderr.log"
stdout_path       APP_ROOT + "/log/unicorn.stdout.log"


before_fork do |server, worker|
  # disconect activerecord
  defined?(ActiveRecord::Base) && ActiveRecord::Base.connection.disconnect!

  old_pid = APP_ROOT + '/tmp/pids/unicorn.pid.oldbin'
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      puts "Old master alerady dead"
    end
  end
end

after_fork do |server, worker|
  # connect activerecord
  defined?(ActiveRecord::Base) && ActiveRecord::Base.establish_connection

  child_pid = server.config[:pid].sub('.pid', ".#{worker.nr}.pid")
  system("echo #{Process.pid} > #{child_pid}")
end

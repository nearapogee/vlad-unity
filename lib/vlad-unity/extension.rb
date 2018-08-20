
[
  ["Thread.current[:task]", :move, :relocate],
  ["Rake::RemoteTask", :roles, :hosts_for, :ask]
].each do |methods|
  receiver = methods.shift
  methods.each do |method|
    eval "def #{method} *args, &block; #{receiver}.#{method}(*args, &block);end"
  end
end

class Rake::RemoteTask
  def self.ask name
    set(name) do
      state = `stty -g`

      raise Rake::Error, "stty(1) not found" unless $?.success?

      begin
        system "stty -echo"
        $stdout.print "#{name}: "
        $stdout.flush
        value = $stdin.gets.chomp!
        $stdout.puts
      ensure
        system "stty #{state}"
      end
      value
    end
  end

  def move from, to, options={}
    cmds = ["mv #{from} #{to}"]
    cmds = cmds.map {|c| ["#{sudo_cmd}", c].join(' ')} if options[:sudo]
    run cmds.join(' && ')
  end

  def relocate to, options={}
    tmp_path = ['/tmp', File.basename(to)].join('/')
    put(tmp_path) { yield }
    move tmp_path, to, sudo: true
  end
end

namespace :vlad do
  # Enhance update_symlinks to also symlink a shared_files variable.
  #
  Rake::Task['vlad:update_symlinks'].enhance do
    begin
      ops = []
      unless shared_files.empty?
        shared_files.each do |sp, rp|
          ops << "mkdir -p #{latest_release}/#{File.dirname(rp)}"
          ops << "ln -s #{shared_path}/#{sp} #{latest_release}/#{rp}"
        end
      end
      run ops.join(' && ') unless ops.empty?
    rescue => e
      run "rm -rf #{release_path}"
      raise e
    end
  end

  task :wait do
    continue = false
    begin
      print "Press enter to continue. Ctl-C to quit."
      input = STDIN.gets
      continue = true if input == "\n"
    end while !continue
  end
end

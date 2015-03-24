require 'chef/knife'

module CustomPlugins
  class Scp < Chef::Knife
    banner "knife scp SEARCH_QUERY PATH_OF_LOCAL_FILE_OR_FOLDER PATH_ON_REMOTE_MACHINE"
    
    option :knife_config_path,
      :short => "-c PATH_OF_knife.rb",
      :long  => "--config PATH_OF_knife.rb",
      :description => "Specify path of knife.rb",
      :default => "/etc/chef/knife.rb"
      
    deps do
      require 'chef/search/query'
      require 'net/scp'
      require 'parallel'
    end

    def run
      if name_args.length != 3
        ui.msg "Missing arguments! Unable to execute the command successfully."
        show_usage
        exit 1
      end
      Chef::Config.from_file(File.expand_path("#{config[:knife_config_path"))
      query = name_args[0]
      local_path = name_args[1]
      remote_path = name_args[2]
      query_object = Chef::Search::Query.new
      fqdn_list = Array.new
      query_object.search('node',query) do |node|
        fqdn_list << node.name
      end
      if fqdn_list.length < 1
        ui.msg "No valid servers found to copy the files to"
      end
      unless File.exist?(local_path)
        ui.msg "#{local_path} does not exist on local machine"
        exit 1
      end

      Parallel.each((1..fqdn_list.length).to_a, :in_processes => fqdn_list.length) do |i|
        puts "Copying #{local_path} to #{Chef::Config[:knife][:ssh_user]}@#{fqdn_list[i-1]}:#{remote_path} "
        Net::SCP.upload!(fqdn_list[i-1],"#{Chef::Config[:knife][:ssh_user]}","#{local_path}","#{remote_path}",:ssh => { :keys => ["#{Chef::Config[:knife][:identity_file]}"] }, :recursive => true)
      end
    end
  end
end

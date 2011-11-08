#
# Cookbook Name:: ucengine
# Recipe:: default
#
# Copyright 2011, af83
#
# Apache 2.0
#
include_recipe "erlang"
include_recipe "git"

tmp_dir = "/tmp/ucengine"

# TODO: extract this
case node[:platform]
when "debian", "ubuntu"
  package "erlang-yaws"
  package "erlang-reltool"
  ENV['ERL_LIBS'] = '/usr/lib/yaws'
else
  package "yaws"
end


directory tmp_dir do
  owner "root"
  mode 0755
  action :create
end

bash "clone" do
  cwd tmp_dir
  code <<-EOH
    git clone https://github.com/AF83/ucengine.git
    cd ucengine
    git checkout #{node[:ucengine][:branch]}
  EOH
end

execute "ucengine-build" do
  cwd "/#{tmp_dir}/ucengine"
  command "make clean rel"
end

execute "install" do
  cwd "/#{tmp_dir}/ucengine/rel"
  command "cp -r ucengine #{node[:ucengine][:prefix]}"
end

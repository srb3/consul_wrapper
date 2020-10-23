#
# Cookbook:: consul_wrapper
# Recipe:: default
#
# Copyright:: 2020, Steve Brown
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
user 'consul'
directory node['consul_wrapper']['bin_path'] do
  recursive true
  owner 'consul'
  group 'consul'
end

directory node['consul_wrapper']['data_path'] do
  recursive true
  owner 'consul'
  group 'consul'
end

directory node['consul_wrapper']['var_path'] do
  recursive true
  owner 'consul'
  group 'consul'
end

directory node['consul_wrapper']['config_path'] do
  recursive true
  owner 'consul'
  group 'consul'
end

remote_file node['consul_wrapper']['download_path'] do
  source node['consul_wrapper']['url']
end

archive_file node['consul_wrapper']['download_path'] do
  destination "#{node['consul_wrapper']['tmp_bin_path']}/consul"
  mode '755'
  owner 'consul'
  group 'consul'
end

if platform?('windows')
  powershell_script 'mv_consul_bin' do
    guard_interpreter :powershell_script
    code "cp #{node['consul_wrapper']['tmp_bin_path']}/consul/consul #{node['consul_wrapper']['bin_path']}/consul"
    not_if { ::File.exist?("#{node['consul_wrapper']['bin_path']}/consul/consul") }
  end
else
  bash 'mv_consul_bin' do
    code <<-CODE
      cp #{node['consul_wrapper']['tmp_bin_path']}/consul/consul #{node['consul_wrapper']['bin_path']}/consul
    CODE
    not_if { ::File.exist?("#{node['consul_wrapper']['bin_path']}/consul/consul") }
  end
end

template node['consul_wrapper']['config_file_path'] do
  source 'consul.hcl.erb'
  variables(
    bind: node['consul_wrapper']['bind'],
    server: node['consul_wrapper']['server'],
    bootstrap_expect: node['consul_wrapper']['bootstrap_expect'],
    data_dir: node['consul_wrapper']['data_path'],
    datacenter: node['consul_wrapper']['datacenter']
  )
end

if platform?('windows')
  include_recipe 'consul_wrapper::service'
else
  include_recipe 'consul_wrapper::systemd'
end

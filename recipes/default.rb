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

group 'consul' unless platform?('windows')

user 'consul' do
  gid 'consul'
  not_if { platform?('windows') }
end

directory node['consul_wrapper']['bin_path'] do
  recursive true
  owner 'consul' unless platform?('windows')
  group 'consul' unless platform?('windows')
end

directory node['consul_wrapper']['data_path'] do
  recursive true
  owner 'consul' unless platform?('windows')
  group 'consul' unless platform?('windows')
end

directory node['consul_wrapper']['var_path'] do
  recursive true
  owner 'consul' unless platform?('windows')
  group 'consul' unless platform?('windows')
end

directory node['consul_wrapper']['config_path'] do
  recursive true
  owner 'consul' unless platform?('windows')
  group 'consul' unless platform?('windows')
end

remote_file node['consul_wrapper']['download_path'] do
  source node['consul_wrapper']['url']
end

archive_file node['consul_wrapper']['download_path'] do
  destination "#{node['consul_wrapper']['tmp_bin_path']}/consul"
  mode '755'
  owner 'consul' unless platform?('windows')
  group 'consul' unless platform?('windows')
end

if platform?('windows')
  powershell_script 'mv_consul_bin' do
    code "cp #{node['consul_wrapper']['tmp_bin_path']}\\consul\\consul.exe #{node['consul_wrapper']['bin_path']}\\consul.exe"
    not_if { ::File.exist?("#{node['consul_wrapper']['bin_path']}\\consul.exe") }
  end
else
  bash 'mv_consul_bin' do
    code <<-CODE
      cp #{node['consul_wrapper']['tmp_bin_path']}/consul/consul #{node['consul_wrapper']['bin_path']}/consul
    CODE
    not_if { ::File.exist?("#{node['consul_wrapper']['bin_path']}/consul") }
  end
end

template node['consul_wrapper']['config_file_path'] do
  source 'consul.hcl.erb'
  variables(
    bind: node['consul_wrapper']['bind'],
    server: node['consul_wrapper']['server'],
    bootstrap_expect: node['consul_wrapper']['bootstrap_expect'],
    data_dir: node['consul_wrapper']['data_path'],
    datacenter: node['consul_wrapper']['datacenter'],
    port: node['consul_wrapper']['port']
  )
end

if platform?('windows')
  include_recipe 'consul_wrapper::service'
else
  include_recipe 'consul_wrapper::systemd'
end

template node['consul_wrapper']['populate_script_path'] do
  source 'populate.erb'
  variables(
    script: node['consul_wrapper']['script'],
    bin_path: node['consul_wrapper']['bin_path'],
    log_path: node['consul_wrapper']['var_path'],
    windows: node['consul_wrapper']['windows']
  )
end

if node['consul_wrapper']['script'] != ''
  if platform?('windows')
    powershell_script 'consul_populate_script' do
      code "& #{node['consul_wrapper']['populate_script_path']}"
      not_if { ::File.exist?(node['consul_wrapper']['script_lock_file']) }
    end
  else
    bash 'consul_populate_script' do
      code "bash #{node['consul_wrapper']['populate_script_path']}"
      not_if { ::File.exist?(node['consul_wrapper']['script_lock_file']) }
    end
  end
end

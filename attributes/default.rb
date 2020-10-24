default['consul_wrapper']['linux_url'] = 'https://releases.hashicorp.com/consul/1.8.4/consul_1.8.4_linux_amd64.zip'
default['consul_wrapper']['windows_url'] = 'https://releases.hashicorp.com/consul/1.8.4/consul_1.8.4_windows_amd64.zip'

default['consul_wrapper']['linux_bin_path'] = '/opt/consul/bin'
default['consul_wrapper']['windows_bin_path'] = 'C:\consul\bin'

default['consul_wrapper']['linux_data_path'] = '/opt/consul/data'
default['consul_wrapper']['windows_data_path'] = 'C:/consul/data'

default['consul_wrapper']['linux_var_path'] = '/opt/consul/var'
default['consul_wrapper']['windows_var_path'] = 'C:\consul\var'

default['consul_wrapper']['linux_config_path'] = '/opt/consul/conf'
default['consul_wrapper']['windows_config_path'] = 'C:\consul\conf'

default['consul_wrapper']['bin_path'] = if platform?('windows')
                                          node['consul_wrapper']['windows_bin_path']
                                        else
                                          node['consul_wrapper']['linux_bin_path']
                                        end

default['consul_wrapper']['tmp_bin_path'] = "#{Chef::Config['file_cache_path']}/consul"

default['consul_wrapper']['bin_file_path'] = node['consul_wrapper']['bin_path']

default['consul_wrapper']['url'] = if platform?('windows')
                                     node['consul_wrapper']['windows_url']
                                   else
                                     node['consul_wrapper']['linux_url']
                                   end

default['consul_wrapper']['download_path'] = "#{Chef::Config['file_cache_path']}/consul.zip"

default['consul_wrapper']['bin_path'] = if platform?('windows')
                                          node['consul_wrapper']['windows_bin_path']
                                        else
                                          node['consul_wrapper']['linux_bin_path']
                                        end

default['consul_wrapper']['data_path'] = if platform?('windows')
                                           node['consul_wrapper']['windows_data_path']
                                         else
                                           node['consul_wrapper']['linux_data_path']
                                         end

default['consul_wrapper']['var_path'] = if platform?('windows')
                                          node['consul_wrapper']['windows_var_path']
                                        else
                                          node['consul_wrapper']['linux_var_path']
                                        end

default['consul_wrapper']['config_path'] = if platform?('windows')
                                             node['consul_wrapper']['windows_config_path']
                                           else
                                             node['consul_wrapper']['linux_config_path']
                                           end

default['consul_wrapper']['config_file_path'] = "#{node['consul_wrapper']['config_path']}/consul.hcl"
default['consul_wrapper']['pid_file_path'] = "#{node['consul_wrapper']['var_path']}/PID"

default['consul_wrapper']['bind'] = '0.0.0.0'
default['consul_wrapper']['server'] = true
default['consul_wrapper']['bootstrap_expect'] = 1
default['consul_wrapper']['datacenter'] = 'dc1'

default['consul_wrapper']['script'] = ''
default['consul_wrapper']['scritp_lock_file'] = ''

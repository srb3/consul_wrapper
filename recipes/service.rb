cmd = "#{node['consul_wrapper']['bin_path']}\\consul agent \
-config-dir=#{node['consul_wrapper']['config_path']} -log-level #{node['consul_wrapper']['log_level']}"

windows_service 'consul' do
  action %i[create start]
  binary_path_name cmd
  display_name 'consul'
  startup_type :automatic
end

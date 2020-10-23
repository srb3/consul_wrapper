windows_service 'consul' do
  action :create
  binary_path_name "#{node['consul_wrapper']['bin_file_path']}/consul agent -config-dir=#{node['consul_wrapper']['config_path']} start=auto"
  display_name 'consul'
  startup_type :automatic
end

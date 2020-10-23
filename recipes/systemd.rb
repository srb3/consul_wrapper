e = "#{node['consul_wrapper']['bin_path']}/consul agent -config-dir=#{node['consul_wrapper']['config_path']}"

systemd_unit 'consul.service' do
  content(Unit: {
            Description: 'HashiCorp Consul - A service mesh solution',
            Documentation: 'https://www.consul.io/',
            Requires: 'network-online.target',
            After: 'network-online.target',
            ConditionFileNotEmpty: node['consul_wrapper']['config_file_path']
          },
          Service: {
            User: 'consul',
            Group: 'consul',
            ExecStart: e,
            ExecReload: "#{node['consul_wrapper']['bin_file_path']} reload",
            ExecStop: "#{node['consul_wrapper']['bin_file_path']} leave",
            KillMode: 'process',
            LimitNOFILE: '65536',
            Restart: 'on-failure'
          }.compact,
          Install: {
            WantedBy: 'multi-user.target'
          })
  action :create
end

service 'consul' do
  subscribes :restart, 'systemd_unit[consul.service]'
  subscribes :restart, "template[#{node['consul_wrapper']['config_file_path']}]"
  action %i[enable start]
end

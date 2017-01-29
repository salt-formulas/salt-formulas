nova:
  controller:
    enabled: true
    networking: contrail
    version: liberty
    security_group: false
    vncproxy_url: 127.0.0.1
    dhcp_domain: novalocal
    scheduler_default_filters: "DifferentHostFilter,RetryFilter,AvailabilityZoneFilter,RamFilter,CoreFilter,DiskFilter,ComputeFilter,ComputeCapabilitiesFilter,ImagePropertiesFilter,ServerGroupAntiAffinityFilter,ServerGroupAffinityFilter"
    cpu_allocation_ratio: 16.0
    ram_allocation_ratio: 1.5
    bind:
      private_address: 127.0.0.1
      public_address: 127.0.0.1
      public_name: 127.0.0.1
      novncproxy_port: 6080
    database:
      engine: mysql
      host: localhost
      port: 3306
      name: nova
      user: nova
      password: password
    identity:
      engine: keystone
      host: 127.0.0.1
      port: 35357
      user: nova
      password: password
      tenant: service
    message_queue:
      engine: rabbitmq
      host: 127.0.0.1
      port: 5672
      user: openstack
      password: password
      virtual_host: '/openstack'
    glance:
      host: 127.0.0.1
      port: 9292
    network:
      engine: neutron
      host: 127.0.0.1
      port: 9696
      mtu: 1500
    metadata:
      password: password
    cache:
      engine: memcached
      members:
      - host: 127.0.0.1
        port: 11211

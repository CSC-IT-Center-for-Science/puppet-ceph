#
# Author: Francois Charlier <francois.charlier@enovance.com>
#
# Copyright (C) 2014 eNovance SAS <licensing@enovance.com>
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# = Class: ceph::client
#
# Provides just the required configuration to run a Ceph client
#
# == Parameters
#
# [*monitors*]
#   (required) List of monitors addresses (not validated, can be plain IPv4,
#   IPv6 or hostnames)
#   Example: ['[2a07:9a03:1:1:ec15:7aff:fe6e:41f0]', ...]
#            ['10.10.26.3', '10.10.26.4', ...]
#            ['mon0.example.com', 'mon1.example.com', ...]
#
# [*keys*]
#   (required) List of pairs of key names & secrets.
#   At least a key named 'admin' should be passed.
#   Example: {
#              'admin' => {
#                secret       => 'secretadmin'
#                keyring_path => '/etc/ceph/ceph.client.admin.keyring'
#              },
#              'client1' => {
#                secret       => 'secretclient1',
#                keyring_path => '/etc/ceph/ceph.client.client1.keyring'
#              }
#            }
#   Note: if path is ommited, the current default from enovance/puppet-ceph
#   will be used: '/var/lib/ceph/tmp/${name}.keyring' which might be unsafe
#   Note: If a radosgw key is given (name radosgw.something) a default
#   radosgw config is set up.
#
# [*keystone_auth_url*]
#   (optional) If radosgw is configured it uses to keystone authentication.
#   This parameter is the auth url for keystone.
#
# [*keystone_admin_token*]
#   (optional) If radosgw is configured it uses to keystone authentication.
#   Radosgw does not have an openstack service account, it needs the keystone
#   admin token to talk to keystone.
#
# [*radosregion*]
#   (optional) If radosgw is configured, it can be set up in a federated way
#   with regions and zones. This is the master region.
#
# [*radoszone*]
#   (optional) If radosgw is configured, it can be set up in a federated way
#   with regions and zones. This is the master zone.
#
class ceph::client (
  $monitors,
  $keys,
  $keystone_auth_url    = undef,
  $keystone_admin_token = undef,
  $radosregion          = undef,
  $radoszone            = undef,
  $radosgw_use_apache   = true,
  $radosgw_port         = 8443,
) {

  package { 'ceph':
    ensure => present
  }

  file { '/etc/ceph/ceph.conf':
    owner   => 'root',
    group   => '0',
    mode    => '0644',
    content => template('ceph/ceph-client.conf.erb'),
    require => Package['ceph']
  }

  create_resources('ceph::key', $keys)

}

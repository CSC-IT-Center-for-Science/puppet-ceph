# Configure yum repository
#
# == Parameters
#
# [*release*]
#   (Optional) The ceph release name
#   Default to 'cuttlefish'
#
# == Dependencies
#
# none
#
# == Authors
#
#  Francois Charlier francois.charlier@enovance.com
#
# == Copyright
#
# Copyright 2012 eNovance <licensing@enovance.com>
#
class ceph::yum::ceph (
  $release = 'cuttlefish'
) {
  yumrepo { 'ceph':
    descr    => "Ceph ${release} repository",
    baseurl  => "https://download.ceph.com/rpm-${release}/el${::operatingsystemmajrelease}/x86_64/",
    gpgkey   =>
      'https://download.ceph.com/keys/release.asc',
    gpgcheck => 1,
    enabled  => 1,
    priority => 5,
    before   => Package['ceph'],
  }
}

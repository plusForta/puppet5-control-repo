# class profile::base
# included for every system in the fleet.
class profile::base {
  class { '::ntp': }
}

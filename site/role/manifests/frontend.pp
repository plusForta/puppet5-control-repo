#
# This role defines all the profiles required for a frontend CMS server.
#

class role::frontend: {

  include ::profile::kirby

}

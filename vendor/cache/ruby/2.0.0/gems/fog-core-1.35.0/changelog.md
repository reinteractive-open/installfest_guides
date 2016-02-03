1.34.0 11/24/2015
==========================================================

make mime/types require optional

1.34.0 11/16/2015
==========================================================

make net/ssh and net/scp requires optional

1.33.0 11/15/2015
==========================================================

relax net/ssh and net/scp requirement

1.32.1 08/12/2015
==========================================================

expose identities in models

1.32.0 07/02/2015
==========================================================

fix/refactor service initializers

1.31.1 06/17/2015
==========================================================

fixes around unknown providers/services

1.31.0 06/17/2015
==========================================================

use relative paths
add digital ocean examples
reinstate baremetal
add softlayer examples
add digital ocean v2 support
setup fog model equality to check identities (if available)
use Fog.interval in wait_for
reduce memory footprint
fix account handling

1.30.0 04/02/2015
==========================================================

bump excon dep
use float times, instead of integers for Fog::Time
don't raise if final wait_for yield true
fix bug around formatador and #map on models
fix around `to_time` to avoid conflicts with Rails monkey patches
update specs
update style
fix `WhitelistKeys` for 1.8.7
remove unreachable code
convert hash helpers to minispec
fix require order for coverage
fix ruby 2.2 warning
bump excon dependency
fix readme link

1.29.0 02/19/2015
==========================================================

minor refactoring
add ability to add additional user agent info to requests

1.28.0 01/30/2015
==========================================================

add Fog::Baremetal

1.27.4 01/26/2015
==========================================================

model fix for new formatador usage
fixes around formatador delegation

1.27.3 12/01/2014
==========================================================

rubocop fixes for fog collection
simpler ruby version checking/skipping
fix requires_one

1.27.2 18/12/2014
==========================================================

fix several requires in service abstraction code

1.27.1 12/12/2014
==========================================================

fix typo in model load paths fix

1.27.0 12/12/2014
==========================================================

return fog/bin stuff to fog/fog
add support for multiple request/model load paths


1.26.0 12/02/2014
==========================================================

remove rackspace logic
use new travis builds
fix error handling around credential fetch
move fog/bin stuff to fog-core
fix circular reference in collection.rb


1.25.0 11/18/2014
==========================================================

add alias options for associations
improve spec message
add feature to overwrite keys on hash of attributes generation
remove method_missing from model
add rubocop
fix rubocop warnings
return collections on association getters
fix require bug in service
put fog and fog-core versions in user agent
don't mutate/destroy encoding in get_body_size
fix error output in from const_get usage
separate to have distinct version from fog


1.24.0 08/26/2014
==========================================================

fixes for defaulting attributes
add method for getting all attributes
add methods for associations
add all_attributes, all_associations and all_associations_and_attributes helper methods
remove no-longer-needed gem update on travis
add all_values
fixes to avoid path conflicts with fog/fog

1.23.0 07/16/2014
==========================================================

attribute whitelisting
abstract out stringify for possible reuse
more specific naming
reorg
add path_prefix
fix time conversion to work with XMLRPC
add more specific per-type attribute tests
lock down rest-client for 1.8.7
allow namespace flipflop for dns
fix identity lookup
better default attribute value setting
bump excon

1.22.0 04/17/2014 1c086852e40e4c1ad7ed138834e4a1505ddb1416
==========================================================

attribute whitelisting
abstract out stringify for possible reuse
more specific naming
reorg
add path_prefix
fix time conversion to work with XMLRPC
add more specific per-type attribute tests
lock down rest-client for 1.8.7
allow namespace flipflop for dns
fix identity lookup
better default attribute value setting
bump excon

1.22.0 04/17/2014 1c086852e40e4c1ad7ed138834e4a1505ddb1416
==========================================================

tests/cleanup/fixes

1.21.1 03/18/2014 3a803405ba60ded421f4bd14677cd3c76cb7e6ab
==========================================================

remove json/xml modules and code
add travis/coveralls
update from upstream
bump/loosen excon dependency

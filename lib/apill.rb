require 'kaminari'

require 'apill/version'

require 'apill/configuration'
require 'apill/matchers/accept_header_matcher'
require 'apill/matchers/subdomain_matcher'
require 'apill/matchers/version_matcher'
require 'apill/mixins/sortable'
require 'apill/mixins/queryable'
require 'apill/mixins/pageable'

require 'apill/middleware/api_request'

require 'apill/responses/invalid_api_request_response'
require 'apill/responses/invalid_subdomain_response'

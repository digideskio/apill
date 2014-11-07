Version v2.2.0 - November 7, 2014
================================================================================

Feature
--------------------------------------------------------------------------------
  * Add RailsRequest
  * Default 'allowed_subdomains' to 'api'
  * Add AcceptHeader#to_s
  * Add AcceptHeader#invalid?

Version v2.1.0 - November 6, 2014
================================================================================

Feature
--------------------------------------------------------------------------------
  * Allow VersionMatcher to match against default version in config

Version v2.0.1 - November 5, 2014
================================================================================

Bugfix
--------------------------------------------------------------------------------
  * Add missing require statements

Docs
--------------------------------------------------------------------------------
  * Add CHANGELOG

Version v2.0.0 - November 5, 2014
================================================================================

Feature
--------------------------------------------------------------------------------
  * Add ApiRequest middleware
  * Add Configuration
  * Update version matcher from Rack to Rails
  * Update the invalid accept header matcher to Rack
  * Update accept header matcher to work with Rack instead of Rails
  * Add InvalidSubdomainResponse
  * Added InvalidSubdomainError
  * Update subdomain matcher to work with Rack instead of Rails
  * Convert to CircleCI

Bugfix
--------------------------------------------------------------------------------
  * Fix references from API_APPLICATION to API_APPLICATION_NAME

Version v1.6.0 - June 28, 2014
================================================================================

Bugfix
--------------------------------------------------------------------------------
  * Don't use instance variables for storing the headers

Version v1.5.0 - June 26, 2014
================================================================================

Feature
--------------------------------------------------------------------------------
  * ResourceNotFoundErrors always return an array for resource ids

Version v1.4.0 - June 3, 2014
================================================================================

Feature
--------------------------------------------------------------------------------
  * Add RescuableResource module
  * Add RescuableResource

Uncategorized
--------------------------------------------------------------------------------
  * Allow the Apill accept header to match either a literal accept header or one
    that is passed in via the request parameters
  * Make sure the Apill AcceptHeader can be initialized with nil or an empty
    string
  * Update Apill so that it can find the accept header information in the params
    as well as in the literal HTTP header
  * The InvalidApiRequestResponse needs the error text to be wrapped in an array
    (that's what Rack expects)
  * The apill error requires the accept_header to be passed in so that we can
    display it to the user
  * Add SubdomainMatcher to Apill
  * Update human_error in apill to 1.2
  * Add require paths to apill so that we can require apill and autoload the
    rest of the dependencies
  * Add the apill gem to our lib directory. It handles all of the API
    request/header matching. It will eventually be extracted out.


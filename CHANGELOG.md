Version v4.2.0 - November 1, 2015
================================================================================

Changed
--------------------------------------------------------------------------------
  * requested_user_id to handle if an ID was passed as empty string
  * from passing requested_user_id to params
  * Renamed api_resource to authorized_collection
  * AuthorizableResource to know the difference between parameters
  * AuthorizedResource constantization to default to apill
  * Rename NON_SPECIFIC_RESOURCE_ACTIONS
  * Rename Authorizer module to Authorizers
  * JsonWebToken to extract common errors into a constant
  * Rename raw_token parameter to encrypted_token
  * Rename JsonWebToken.convert to .from_jwe
  * Rename token param to data
  * Regex to grab the controller resource to something more robust
  * Authorizer::Scope to default to returning an empty list
  * Authorizer::Parameters to return params passed in by default
  * Move human_error includes before apill includes in Resource
  * ProcessableResource to privatize methods

Removed
--------------------------------------------------------------------------------
  * Methods from AuthorizableResource moved to Filtering param
  * ProcessableResource and move into AuthorizableResource
  * encrypted_token parameter

Fixed
--------------------------------------------------------------------------------
  * AuthorizableResource#authorized_params to call the proper method
  * Reference to constant
  * Add missing requires

Added
--------------------------------------------------------------------------------
  * Authorizers::Parameters::Resource
  * parameter processing to Authorizers::Parameters::Filtering
  * Parameters::Filtering
  * Methods to JsonWebToken for converting into JWT formats
  * JsonWebToken.from_jws
  * AuthorizableResource
  * extracted out a Resource::Naming module
  * token, user, requested_user_id, scope_root to Authorizer::Scope
  * Authorizer::Scope
  * token, user and params to Authorizer::Parameter
  * Authorizer::Parameters
  * Default queries to Authorizer::Query
  * token, user and resource to Authorizer::Query
  * Authorizer::Query

Version v4.1.0 - October 22, 2015
================================================================================

Changed
--------------------------------------------------------------------------------
  * Header token detection to detect Base64 and JWT tokens
  * Rename TOKEN_PATTERN to JSON_WEB_TOKEN_HEADER_PATTERN
  * From talking about generic Base64 to Json Web Tokens
  * Require Base64 tokens to have a Base64 pattern
  * authorization_token_from_params into each individual request
  * Param name passed in if it's a simple Base64 token

Removed
--------------------------------------------------------------------------------
  * raw_authorization_token_from_header

Added
--------------------------------------------------------------------------------
  * Ability for request to handle if no param token is passed in
  * Ability for the Base64 token to handle null and invalid tokens
  * Ability for requests to handle Base64 tokens in the params
  * Missing requires
  * Tokens::Base64 for simple Base64 tokens
  * BASE64_PATTERN
  * Base Null and Invalid tokens

Fixed
--------------------------------------------------------------------------------
  * Don't forget to convert requests on all matches

Version v4.0.3 - October 21, 2015
================================================================================

Fixed
--------------------------------------------------------------------------------
  * bug in apill matchers generic module

Version v4.0.2 - October 21, 2015
================================================================================

Changed
--------------------------------------------------------------------------------
  * Requests::Base not to re-resolve an already transformed request
  * Responses::InvalidToken to return the realm
  * to_h on null/invalid tokens to an array of hashes
  * Header parameter used to pass the decrypted token information

Version v3.1.3 - October 21, 2015
================================================================================

Fixed
--------------------------------------------------------------------------------
  * CONTENT_TYPE being passed with multiple content types

Version v4.0.1 - October 19, 2015
================================================================================

Fixed
--------------------------------------------------------------------------------
  * Revert putting request in initializer on matchers

Version v4.0.0 - October 19, 2015
================================================================================

Added
--------------------------------------------------------------------------------
  * Token decryption and verification to the middleware
  * Responses::InvalidToken
  * Errors::InvalidToken
  * token_private_key to Requests::Base initializer
  * token_private_key to configuration
  * Tokens::RequestAuthorization
  * Tokens::NullAuthorization
  * Tokens::InvalidRequestAuthorization

Changed
--------------------------------------------------------------------------------
  * Matchers to take the request on initialization
  * Extract local variable
  * Rename RailsRequest to Rails
  * Rename RackRequest to Rack
  * Rename VersionMatcher to Version
  * Rename GenericMatcher to Generic
  * Rename InvalidSubdomainError to InvalidSubdomain
  * Rename AcceptHeaderMatcher to AcceptHeader
  * Rename SubdomainMatcher to Subdomain
  * Rename InvalidApiRequestError to InvalidApiRequest
  * Rename InvalidApiRequestResponse to InvalidApiRequest
  * Rename InvalidSubdomainResponse to InvalidSubdomain
  * ApiRequest middleware to use a short circuit
  * ApiRequest middleware to use short circuit
  * Requests to allow parsing of authorization tokens
  * Requests::Base to use keyword parameters
  * Request class structure

Version v3.1.2 - August 22, 2015
================================================================================

Fixed
--------------------------------------------------------------------------------
  * Infinite ranges are not supported by searchkick

Version v3.1.1 - August 21, 2015
================================================================================

Added
--------------------------------------------------------------------------------
  * The ability to convert infinite ranges

Changed
--------------------------------------------------------------------------------
  * Simplify the range regex
  * range conversion to allow underscores in numbers

Version v3.1.0 - August 21, 2015
================================================================================

Added
--------------------------------------------------------------------------------
  * value formatting for ranges to filter parameters

Version v3.0.7 - August 13, 2015
================================================================================

Added
--------------------------------------------------------------------------------
  * dup to parameters

Changed
--------------------------------------------------------------------------------
  * Make sure that blank parameters are not included in indexing

Version v3.0.6 - August 12, 2015
================================================================================

Changed
--------------------------------------------------------------------------------
  * type to json_api_type to match AMS changes

Version v3.0.5 - August 12, 2015
================================================================================

Changed
--------------------------------------------------------------------------------
  * Paging to use resource instead of processed

Fixed
--------------------------------------------------------------------------------
  * Indicies always need their for_query method called

Version v3.0.4 - August 11, 2015
================================================================================

Changed
--------------------------------------------------------------------------------
  * Resource to be a meta module

Version v3.0.3 - August 11, 2015
================================================================================

Fixed
--------------------------------------------------------------------------------
  * Sort not being permitted properly as a String

Version v3.0.2 - August 11, 2015
================================================================================

Added
--------------------------------------------------------------------------------
  * default returns for metadata as well

Version v3.0.1 - August 11, 2015
================================================================================

Added
--------------------------------------------------------------------------------
  * Check which ignores non-ideomatic page param names
  * Check to skip process step without appropriate params
  * Defaults for all parameters if none are passed in

Removed
--------------------------------------------------------------------------------
  * Default sort order

Changed
--------------------------------------------------------------------------------
  * Filter parameters to extract valid parameters

Version v3.0.0 - August 11, 2015
================================================================================

Removed
--------------------------------------------------------------------------------
  * kaminiari as a strict dependency of apill

Changed
--------------------------------------------------------------------------------
  * Error classes for the new version of human_error
  * All mixins massively updated

Added
--------------------------------------------------------------------------------
  * .ctags configuration file

Version v2.9.0 - August 7, 2015
================================================================================

Changed
--------------------------------------------------------------------------------
  * CONTENT_TYPE to regular application/json from JSON API type

Version v2.8.1 - August 6, 2015
================================================================================

Fixed
--------------------------------------------------------------------------------
  * Parameters#process deleting query params with no dashes

Version v2.8.0 - August 3, 2015
================================================================================

Added
--------------------------------------------------------------------------------
  * Parameter processing to the middleware
  * Parameters for processing API parameters
  * Serializer support for JSON API

Changed
--------------------------------------------------------------------------------
  * meta tages to dasherized instead of underscored

Version v2.7.1 - June 3, 2015
================================================================================

Fixed
--------------------------------------------------------------------------------
  * Rack query string accept params need unescaped

Version v2.7.0 - May 25, 2015
================================================================================

Changed
--------------------------------------------------------------------------------
  * Queryable to only search for non-blank values

Version v2.6.1 - April 15, 2015
================================================================================

Changed
--------------------------------------------------------------------------------
  * Allow HTTP_HOST to be blank

Version v2.6.0 - April 11, 2015
================================================================================

Version v2.6.0 - April 10, 2015
================================================================================

Changed
--------------------------------------------------------------------------------
  * filtered_resource to constantize
  * filtered_resource to @paginated_resource
  * Queryable to handle if we get an ElasticSearch result

Added
--------------------------------------------------------------------------------
  * Indexable for running indexing queries

Version v2.5.1 - March 26, 2015
================================================================================

Added
--------------------------------------------------------------------------------
  * Deploy script
  * Rubygems settings

Version v2.5.0 - March 10, 2015
================================================================================

Changed
--------------------------------------------------------------------------------
  * Queryable to handle pulling query params off the base params

Version v2.4.0 - February 27, 2015
================================================================================

Changed
--------------------------------------------------------------------------------
  * Allow queryable to have filters with no arguments

Version v2.3.3 - February 24, 2015
================================================================================

Fixed
--------------------------------------------------------------------------------
  * Configuration so that allowed_subdomains is properly defaulted
  * Middleware not to check for accept header on non-API subdomains

Changed
--------------------------------------------------------------------------------
  * SubdomainMatcher to pull logic to get subdomain into a method
  * SubdomainMatcher so that it needs to be instantiated to be used

Added
--------------------------------------------------------------------------------
  * SubdomainMatcher#allowed_api_subdomains?
  * configuration option for allowed API subdomains

Version v2.3.2 - February 6, 2015
================================================================================

Changed
--------------------------------------------------------------------------------
  * From a defined? check to a respond_to? check

Version v2.3.1 - January 30, 2015
================================================================================

Changed
--------------------------------------------------------------------------------
  * respond_to? to defined?

Added
--------------------------------------------------------------------------------
  * filter_data to Queryable to make it consistent with other mixins

Version v2.3.0 - January 28, 2015
================================================================================

Added
--------------------------------------------------------------------------------
  * Rubocop configuration
  * Sortable mixin
  * Queryable mixin
  * the Pageable mixin

Changed
--------------------------------------------------------------------------------
  * Queryable mixin to not require queryable_attributes

Removed
--------------------------------------------------------------------------------
  * require line for a file which no longer exists

Bugfix
--------------------------------------------------------------------------------
  * require statments were incorrect

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


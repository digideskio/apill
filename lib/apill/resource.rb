require 'apill/processable_resource'
require 'human_error/rescuable_resource'
require 'human_error/verifiable_resource'

module  Apill
module  Resource
  def self.included(base)
    base.include HumanError::RescuableResource
    base.include HumanError::VerifiableResource
    base.include Apill::ProcessableResource
  end
end
end

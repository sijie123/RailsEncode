class EncodeJob < ApplicationRecord
  #serialize :params, Hash

  belongs_to :user
  belongs_to :server
  
  
end

class User < ApplicationRecord
  has_many :encode_jobs
  
  has_secure_password
end

class TransferJob < ApplicationJob
  queue_as :default
  

  def perform(filename, pull = true, *args)
    
  end
end

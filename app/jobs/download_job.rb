class DownloadJob < ApplicationJob
  queue_as :default
  
  def perform(url, *args)
    
    
  end
end

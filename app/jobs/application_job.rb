class ApplicationJob < ActiveJob::Base

#  def queue_next_step(current, job)
#    case current
#    when 'uploaded' #started, + uploaded file already
#      TransferJob.perform_later(job)
#    when 'started' #started, but need to download file from ext server
#      DownloadJob.perform_later(job)
#    when 'downloaded'
#      TransferJob.perform_later(job)
#    when 'transferred'
#      EncodeJob.perform_later(job)
#   when 'encoded'
#      TransferJob.perform_later(job)
#    when 'done'
#      #send an email?
#    else
#      #error
#    end
#  end
  
end

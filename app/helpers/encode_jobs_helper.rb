module EncodeJobsHelper
  def humanParams(pa)
    pa.each do |k,v|
      "#{k} --> #{v}\n"
    end
  end

  def humanStatus(status)
    case status
    when 0
      "Waiting in queue."
    when 1
      "Job accepted. Transferring file."
    when 2
      "File transferred. Encoding now. Progress here."
    when 3
      "File encoded successfully. Preparing download."
    when 4
      "Job completed. Download here:"
    when -1
      "Cannot initialize job."
    when -2
      "File transfer failed."
    when -3
      "File encoding failed."
    when -4
      "File transfer failed."
    else
      "Some error occured"
    end
  end
  def options_for_select_aencoder
    [['libmp3lame', 'libmp3lame'], ['libfaac', 'libfaac']]
  end
  def options_for_select_vencoder
    [['libx264', 'libx264'], ['libx265', 'libx265']]
  end
  
  def options_for_select_preset
    [['ultrafast', 'ultrafast'], ['superfast', 'superfast'], ['veryfast', 'veryfast'],
    ['faster', 'faster'], ['fast','fast'], ['medium', 'medium'], ['slow', 'slow'],
    ['slower', 'slower'], ['veryslow', 'veryslow'], ['placebo', 'placebo'] ]
  end
  
  def options_for_select_tune
    [['film', 'film'], ['animation', 'animation'], ['grain', 'grain'], ['zerolatency', 'zerolatency'],
      ['stillimage', 'stillimage'], ['psnr','psnr'], ['ssim', 'ssim'], ['fastdecode', 'fastdecode']]
  end
end

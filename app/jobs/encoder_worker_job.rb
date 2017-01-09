class EncoderWorkerJob < ApplicationJob
  queue_as :default
  require 'net/sftp'
  require 'uri'
  require 'streamio-ffmpeg'
  require 'httparty'
  
  def convert_crf(value)
    ["-crf", value]
  end
  
  def convert_tune(value)
    ["-tune", value]
  end

  def update_phase(phase, extras = '')
    @job.phase = phase;
    @job.extras = extras if extras != ''
    update()
  end
  
  def update_filename(filename)
    @job.filename = filename
    update()
  end
  
  def update_outname(outname)
    @job.outname = outname
    update()
  end
  
  def update_server()
    @job.server_id = @server_id
    update()
  end
  
  def update()
    if not @job.save #idk what to do lol
    end
  end
  
  def transfer(pull = true)
    return if master?
    begin
      Net::SFTP.start(@host, @username, :password => @password) do |sftp|
        # download a file or directory from the remote host
        
        sftp.download!(@job.filename, @job.filename) if pull #local filename and directory same as master node.
        sftp.upload!(@job.outname, @job.outname) if not pull #push
      end
      update_phase(2, '0') if pull
      update_phase(4) if not pull
    rescue SystemCallError
      if (pull)
        update_phase(-2)
      else
        update_phase(-4)
      end
    end
  end
  
  def download()
    partial = Time.now().to_i.to_s + File.basename(URI.parse(@job.filename).path)
    filename = @fileroot + partial
    p filename
    outname = @fileout + partial
    begin
#      f = open(filename, "w+")
      #x = HTTP.get(@job.filename)
      
#      uri = URI(@job.filename)

#      Net::HTTP.start(uri.host, uri.port) do |http|
#        request = Net::HTTP::Get.new uri

#        http.request request do |response|
#          response.read_body do |chunk|
#            f.write chunk
#          end
#        end
#      end
      
      File.open(filename, "wb") do |file|
        response = HTTParty.get(@job.filename, stream_body: true) do |fragment|
          #print "."
          file.write(fragment)
        end
      end

     update_outname(outname)
     update_filename(filename)
     update_phase(2, '0');

    rescue SystemCallError
      #Error out the job
      update_phase(-2);
    end
  end
  
  def encode()
    # Do something later
    begin
      FFMPEG.ffmpeg_binary = '/root/ffmpeg/ffmpeg-10bit'
      FFMPEG.ffprobe_binary = '/root/ffmpeg/ffprobe'
      movie = FFMPEG::Movie.new(@job.filename)
      
      #options = {
      #video_codec: "libx264", frame_rate: 10, resolution: "320x240", video_bitrate: 300, video_bitrate_tolerance: 100,
      #aspect: 1.333333, keyframe_interval: 90, x264_vprofile: "high", x264_preset: "slow",
      #audio_codec: "libfaac", audio_bitrate: 32, audio_sample_rate: 22050, audio_channels: 1,
      #threads: 2, custom: %w(-vf crop=60:60:10:10 -map 0:0 -map 0:1)
      #}
      options = @job.params
      counter = 0
      movie.transcode(@job.outname, options) do |progress|
        if (counter % 2 == 0)
          update_phase(2, progress.to_s)
        end
        counter += 1;
      end
    update_phase(3,'0');  
    
    #rescue SystemCallError
    #  update_phase(-3);
    #end
    end

  end
  
  def require_transfer?
    return !@job.download
  end


  def perform(job)
    @job = job
    @slave = Workspace::Application.config.slave
    @host = Workspace::Application.config.host
    @username = Workspace::Application.config.username
    @password = Workspace::Application.config.password
    @server_id = Workspace::Application.config.server_id
    @fileroot = Workspace::Application.config.work_dir
    @fileout = Workspace::Application.config.output_dir
    
    return if (@job.phase != 0) #ensures that any failed or dead tasks don't start again.
    
    update_server()
    update_phase(1)

    if require_transfer?
      transfer()
    else
      download()
    end
    
    return if (@job.phase < 0)

    encode()
    
    return if (@job.phase < 0)

    transfer()
    
    return if (@job.phase < 0)

  end
end

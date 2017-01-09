class EncodeJobsController < ApplicationController
  require 'json'
  #before_action :get_user, only: [:show, :edit, :update, :create, :destroy]
  before_action :set_encode_job, only: [:show, :edit, :update, :destroy]
  

  # GET /encode_jobs
  # GET /encode_jobs.json
  def index
    @encode_jobs = EncodeJob.all
  end

  # GET /encode_jobs/1
  # GET /encode_jobs/1.json
  def show
  end

  # GET /encode_jobs/new
  def new
    @encode_job = EncodeJob.new
  end

  # GET /encode_jobs/1/edit
  def edit
  end

  # POST /encode_jobs
  # POST /encode_jobs.json
  def create
    #p = encode_job_params
    p = encode_job_params
    
    pa = encode_job_params[:params]
    #render plain: JSON.parse(pa.to_h.to_json).inspect

    if p[:upload]
      uploaded_file = p[:upload]
      #fname = "file.tmp"
      partial = Time.now().to_i.to_s + uploaded_file.original_filename
      fname = Rails.root.join(Workspace::Application.config.work_dir, partial)
      oname = Rails.root.join(Workspace::Application.config.output_dir, partial)
      File.open(fname, 'wb') do |file|
        file.write(uploaded_file.read)
      end
      p[:filename] = fname
      p[:outname] = oname
      p[:download] = false
    
    elsif p[:url]
      p[:filename] = p[:url]
      p[:outname] = "tbd"
      p[:download] = true
      
    end
    
    p[:user_id] = current_user.id
    p[:phase] = 0
    
    p[:params] = pa.to_json
    p[:server_id] = 0
    p[:extras] = ''
    p.delete(:url)
    p.delete(:upload)
    
    @encode_job = EncodeJob.new(p)
    #render plain: @encode_job.inspect
    
    #x.perform_later(@encode_job)
    
    respond_to do |format|
      if @encode_job.save
        x = EncoderWorkerJob.perform_later(@encode_job)
        format.html { redirect_to @encode_job, notice: 'Encode job was successfully created.' }
        format.json { render :show, status: :created, location: @encode_job }
      else
        format.html { render :new }
        format.json { render json: @encode_job.errors, status: :unprocessable_entity }
      end

  end

  # PATCH/PUT /encode_jobs/1
  # PATCH/PUT /encode_jobs/1.json
  def update
    respond_to do |format|
      if @encode_job.update(encode_job_params)
        format.html { redirect_to @encode_job, notice: 'Encode job was successfully updated.' }
        format.json { render :show, status: :ok, location: @encode_job }
      else
        format.html { render :edit }
        format.json { render json: @encode_job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /encode_jobs/1
  # DELETE /encode_jobs/1.json
  def destroy
    @encode_job.destroy
    respond_to do |format|
      format.html { redirect_to encode_jobs_url, notice: 'Encode job was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_encode_job
      @encode_job = EncodeJob.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def encode_job_params
      #params
      #params.require(:encode_job).permit(:vencoder, :preset, :tune, :crf, :aencoder, :abr, :upload, :title, :url)
      #params.require(:encode_job).require(:params).permit(:vencoder, :preset, :tune)
      params.require(:encode_job).permit(:upload, :title, :url, params: [ :vencoder, :preset, :tune, :crf, :aencoder, :abr ])
    end
    
end

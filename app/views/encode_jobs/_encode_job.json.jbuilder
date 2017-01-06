json.extract! encode_job, :id, :params, :title, :filename, :user_id, :phase, :outname, :created_at, :updated_at
json.url encode_job_url(encode_job, format: :json)
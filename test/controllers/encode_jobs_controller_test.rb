require 'test_helper'

class EncodeJobsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @encode_job = encode_jobs(:one)
  end

  test "should get index" do
    get encode_jobs_url
    assert_response :success
  end

  test "should get new" do
    get new_encode_job_url
    assert_response :success
  end

  test "should create encode_job" do
    assert_difference('EncodeJob.count') do
      post encode_jobs_url, params: { encode_job: { filename: @encode_job.filename, outname: @encode_job.outname, params: @encode_job.params, phase: @encode_job.phase, title: @encode_job.title, user_id: @encode_job.user_id } }
    end

    assert_redirected_to encode_job_url(EncodeJob.last)
  end

  test "should show encode_job" do
    get encode_job_url(@encode_job)
    assert_response :success
  end

  test "should get edit" do
    get edit_encode_job_url(@encode_job)
    assert_response :success
  end

  test "should update encode_job" do
    patch encode_job_url(@encode_job), params: { encode_job: { filename: @encode_job.filename, outname: @encode_job.outname, params: @encode_job.params, phase: @encode_job.phase, title: @encode_job.title, user_id: @encode_job.user_id } }
    assert_redirected_to encode_job_url(@encode_job)
  end

  test "should destroy encode_job" do
    assert_difference('EncodeJob.count', -1) do
      delete encode_job_url(@encode_job)
    end

    assert_redirected_to encode_jobs_url
  end
end

require "nyc_dot_cctv/version"
require 'net/http'

module NycDotCctv
  module_function

  DEFAULT_CAMERA_IP = "207.251.86.238".freeze

  class Error < StandardError; end

  def request_image(cctv_id)
    current_time = Time.now.utc
    uri = URI("http://#{DEFAULT_CAMERA_IP}/cctv#{cctv_id}.jpg?rand=#{Random.rand}:80")
    response = Net::HTTP.get_response(uri)
    {
      status_code: response.code,
      body: response.body,
      requested_at: current_time,
      uri: uri
    }
  end
end

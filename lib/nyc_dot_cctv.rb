require "nyc_dot_cctv/version"
require 'net/http'

module NycDotCctv
  module_function

  class Error < StandardError; end
  DEFAULT_CAMERA_IP = "207.251.86.238".freeze
  DEFAULT_OPTIONS = {
    host: DEFAULT_CAMERA_IP,
    img_type: "jpg".freeze,
    port: "80".freeze
  }

  # @param cctv_id [String]
  # @param custom_opts [Hash]
  # @return [Hash]
  def request_image(cctv_id, custom_opts: {})
    current_time = Time.now.utc
    if invalid_cctv_id?(cctv_id)
      return {
        errors: ["An invalid CCTV ID was provided"],
        requested_at: current_time
      }
    end

    uri = generate_uri(cctv_id, {custom_opts: custom_opts})
    res = Net::HTTP.get_response(uri)
    {
      body: res.body,
      requested_at: current_time,
      status_code: res.code,
      uri: uri
    }
  end

  # Generates a URI to request an image from a specified CCTV camera
  # The default options should work in most cases, but can be overridden.
  # @param cctv_id [String]
  # @param custom_opts [Hash]
  # @return [URI]
  def generate_uri(cctv_id, custom_opts: {})
    opts = DEFAULT_OPTIONS.merge(custom_opts)
    uri = "http://#{cctv_host(opts[:host])}" \
          "/cctv#{cctv_id}.#{opts[:img_type]}" \
          "?rand=#{Random.rand}:#{opts[:port]}"
    URI(uri)
  end

  # Specifies the cctv_host to use. If a valid host isn't
  # specified, the default host is returned
  # @param host [String]
  # @return [Boolean]
  def cctv_host(host)
    return DEFAULT_CAMERA_IP if invalid_host?(host)
    host
  end

  # A host is invalid if it's not a string, or if it's empty.
  # example: host = "google.com"
  # @param host [String]
  # @return [Boolean]
  def invalid_host?(host)
    !host.class.to_s.eql?("String") || host.empty?
  end

  # Determine whether a provided cctv_id is invalid
  # @param cctv_id [String]
  # @return [Hash]
  def invalid_cctv_id?(cctv_id)
    invalid_host?(cctv_id)
  end
end

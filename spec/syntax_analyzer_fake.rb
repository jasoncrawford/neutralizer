require 'json'
require 'digest'
require 'fileutils'
require_relative '../syntax_analyzer'

class SyntaxAnalyzerFake
  def new_requests_allowed?
    true
  end

  def dirpath
    'spec/fakes'
  end

  def key_for_params(params)
    Digest::MD5.hexdigest params
  end

  def filepath_for_params(params)
    "#{dirpath}/#{key_for_params params}.json"
  end

  def serialize(response)
    response.to_h.to_json
  end

  def deserialize(string)
    Google::Cloud::Language::V1::AnalyzeSyntaxResponse.new(JSON.parse string)
  end

  def get_fake_response(params)
    filepath = filepath_for_params params
    return nil unless File.exists? filepath
    deserialize(File.read filepath)
  end

  def record_fake_response(params, response)
    FileUtils.mkdir_p dirpath
    filepath = filepath_for_params params
    File.write filepath, serialize(response)
  end

  def with_fake_response(params, &block)
    fake_response = get_fake_response params
    return fake_response if fake_response

    raise "unexpected request #{params.inspect}" unless new_requests_allowed?

    response = @block.call

    record_fake_response params, response
    response
  end
end

class SyntaxAnalyzer
  orig_analyze = instance_method :analyze

  def fake
    @fake ||= SyntaxAnalyzerFake.new
  end

  def analyze(text)
    fake.with_fake_response(text) do
      orig_analyze text
    end
  end
end

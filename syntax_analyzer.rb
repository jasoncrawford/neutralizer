require 'json'
require 'digest'
require 'fileutils'
require 'google/cloud/language'
require 'google/cloud/language/v1'

class SyntaxAnalyzer
  def initialize
    @fake = SyntaxAnalyzerFake.new
  end

  def credentials
    {
      type: "service_account",
      project_id: "blind-audition-222804",
      private_key_id: ENV['GOOGLE_APPLICATION_PRIVATE_KEY_ID'],
      private_key: ENV['GOOGLE_APPLICATION_PRIVATE_KEY'],
      client_email: "nlp-958@blind-audition-222804.iam.gserviceaccount.com",
      client_id: "107848770294889190073",
      auth_uri: "https://accounts.google.com/o/oauth2/auth",
      token_uri: "https://oauth2.googleapis.com/token",
      auth_provider_x509_cert_url: "https://www.googleapis.com/oauth2/v1/certs",
      client_x509_cert_url: "https://www.googleapis.com/robot/v1/metadata/x509/nlp-958%40blind-audition-222804.iam.gserviceaccount.com"
    }
  end

  def client
    @client ||= Google::Cloud::Language.new credentials: credentials
  end

  def analyze(text)
    document = {content: text, type: :PLAIN_TEXT}
    encoding_type = Google::Cloud::Language::V1::EncodingType::UTF8
    client.analyze_syntax document, encoding_type: encoding_type
  end
end

class SyntaxAnalyzerFake
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

    response = @block.call params

    record_fake_response params, response
    response
  end
end

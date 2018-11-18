require 'json'
require 'digest'
require 'fileutils'
require 'google/cloud/language'
require 'google/cloud/language/v1'

class SyntaxAnalyzer
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

  def dirpath
    'spec/fakes'
  end

  def get_fake_response(text)
    key = Digest::MD5.hexdigest text
    filepath = "#{dirpath}/#{key}.json"
    return nil unless File.exists? filepath
    json = File.read(filepath)
    Google::Cloud::Language::V1::AnalyzeSyntaxResponse.new(JSON.parse json)
  end

  def record_fake_response(text, response)
    key = Digest::MD5.hexdigest text
    FileUtils.mkdir_p dirpath
    filepath = "#{dirpath}/#{key}.json"
    File.open(filepath, "w") {|f| f.write response.to_h.to_json}
  end

  def analyze(text)
    fake_response = get_fake_response text
    return fake_response if fake_response

    document = {content: text, type: :PLAIN_TEXT}
    encoding_type = Google::Cloud::Language::V1::EncodingType::UTF8
    response = client.analyze_syntax document, encoding_type: encoding_type

    record_fake_response text, response
    response
  end
end

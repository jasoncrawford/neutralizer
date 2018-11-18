require 'json'
require 'google/cloud/language'

class SyntaxAnalyzer
  def credentials_json
    {
      "type": "service_account",
      "project_id": "blind-audition-222804",
      "private_key_id": ENV['GOOGLE_APPLICATION_PRIVATE_KEY_ID'],
      "private_key": ENV['GOOGLE_APPLICATION_PRIVATE_KEY'],
      "client_email": "nlp-958@blind-audition-222804.iam.gserviceaccount.com",
      "client_id": "107848770294889190073",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/nlp-958%40blind-audition-222804.iam.gserviceaccount.com"
    }
  end

  def credentials_io
    StringIO.new(credentials_json.to_json)
  end

  def credentials
    credentials_json.to_json
  end

  def client
  end
end

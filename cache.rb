require 'digest'
require 'redis'

class Cache
  def client
    @client ||= Redis.new
  end

  def flush
    client.flushdb
  end

  def key_for_text(text)
    Digest::MD5.hexdigest text
  end

  def save(text, response)
    key = key_for_text text
    client.set key, response
  end

  def with_cache(text)
    key = key_for_text text
    response = client.get key
    return response unless response.nil?
    yield
  end
end

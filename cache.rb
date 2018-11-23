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
    yield
  end
end

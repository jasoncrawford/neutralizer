class Cache
  def client
    @client ||= Redis.new
  end

  def flush
    @client.flushdb
  end

  def key_for_text(text)
  end

  def save(text, response)
  end

  def with_cache(text)
    yield
  end
end

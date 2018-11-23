class Cache
  def client
    @client ||= Redis.new
  end

  def flush
    @client.flushdb
  end
end

class Cache
  def client
    @client ||= Redis.new
  end
end

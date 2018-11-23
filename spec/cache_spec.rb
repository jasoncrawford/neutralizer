require_relative '../cache'

describe Cache do
  let(:cache) { Cache.new }

  context "cache miss" do
    subject { cache.with_cache('foo') { 'bar' } }
    it { is_expected.to be_nil }
  end
end
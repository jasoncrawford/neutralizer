require_relative '../cache'

describe Cache do
  let(:cache) { Cache.new }

  context "cache miss" do
    subject { cache.with_cache('foo') { 'bar' } }
    it { is_expected.to eq('bar') }
  end

  context "cache hit?" do
    before(:all) { @counter = 0 }

    subject { cache.with_cache('foo') { @counter += 1; 'bar' } }

    it { is_expected.to eq('bar') }
    it "should not increment the counter" do
      expect(@counter).to eq(0)
    end
  end
end

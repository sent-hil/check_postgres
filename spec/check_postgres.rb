require_relative "./spec_helper"

describe CheckPostgres do
  subject do
    CheckPostgres.new(TEST_HOST, "monitor")
  end

  it "returns dbstats" do
    subject.dbstats.count.should be_a(Integer)
  end

  it "returns locks" do
    subject.locks[:postgres].should be_a(Integer)
  end

  CheckPostgres::PER_DB_STATS.each do |check|
    it "returns #{check}" do
      subject.send(check)[:postgres].should be_a(Integer)
    end
  end
end

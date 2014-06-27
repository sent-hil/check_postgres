require_relative "./spec_helper"

describe CheckPostgres do
  subject do
    CheckPostgres.new(TEST_HOST, "monitor")
  end

  it "returns dbstats" do
    subject.dbstats.count.should be_a(Integer)
  end

  it "returns connections" do
    subject.backends[:postgres].should be_a(Integer)
  end

  it "returns locks" do
    subject.locks[:postgres].should be_a(Integer)
  end

  it "returns txn_wraparound" do
    subject.txn_wraparound[:postgres].should be_a(Integer)
  end

  it "returns autovac_freeze" do
    subject.autovac_freeze[:postgres].should be_a(Integer)
  end
end

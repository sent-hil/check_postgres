require_relative "./spec_helper"

describe CheckPostgres do
  subject do
    CheckPostgres.new(TEST_HOST, "monitor")
  end

  it "returns dbstats" do
    subject.dbstats.count.should == 4
  end
end

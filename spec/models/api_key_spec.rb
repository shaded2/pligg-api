require 'spec_helper'
require_relative '../../models/api_key.rb'

describe "New API key" do
  before do
    ApiKey.destroy_all
  end

  let(:api_key) { ApiKey.create(:user_id=>1) }

  subject { api_key }

  it { should respond_to :access_token }
  it { should respond_to :expires_at }

  it "expires_at should be 90 days from now" do
    expect((api_key.expires_at - Time.now.utc)/(60 * 60 * 24)).to be_within(0.1).of(90)
  end

end


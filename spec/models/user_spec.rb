require 'spec_helper'
require_relative '../../models/user.rb'

describe "User" do
  before do
    User.destroy_all
  end

  let(:user) { User.create() }

  subject { user }

  it { should respond_to :user_id }
  it { should respond_to :user_login }
  it { should respond_to :user_email }

end


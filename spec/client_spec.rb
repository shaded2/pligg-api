require 'spec_helper'
require_relative '../client.rb'

# NOTE: ALL tests below assumes there is a running service
###########################################################

describe "client" do

  let(:link_data) { {
    :link_status => "new",
    :link_url => "http://test-client.com",
    :link_title => "test test-client title",
    :link_summary => "summary test-client",
    :link_tags => "client-tag1, client-tag2"
  } }

  let(:random_slug) { ('a'..'z').to_a.shuffle[0,8].join }

  let(:user) { User.create(:user_login=>random_slug) }
  let(:api_key) { ApiKey.create(:user_id=>user.user_id)  }

  before (:all) do
    Link.base_uri = "http://localhost:4000"
  end

  it "should get a link" do
    link_data[:link_url] = "#{link_data[:link_url]}/#{random_slug}"
    link = Link.create(link_data)

    link2 = Link.find_by_id(link["link_id"])
    expect(link2['link_url']).to eq link_data[:link_url]
    Link.destroy(link2["link_id"])
  end

  it "should create a link" do
    link_data[:link_url] = "#{link_data[:link_url]}/#{random_slug}"
    link = Link.create(link_data)
    expect(link['link_url']).to eq link_data[:link_url]
    Link.destroy(link["link_id"])
  end

  it "should destroy a link" do
    link_data[:link_url] = "#{link_data[:link_url]}/#{random_slug}"
    link = Link.create(link_data)
    expect(Link.destroy(link['link_id'])).to be true
    expect(Link.find_by_id(link['link_id'])).to be_nil
  end

  it "should get a user via assess_token" do
    #binding.pry
    Link.access_token = api_key.access_token
    my_user = Link.user
    expect(my_user['user_id']).to eq user[:user_id]
  end

end
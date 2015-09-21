require 'spec_helper'
require_relative '../service.rb'

describe "service" do

  #user and api_key mocks
  let(:user) { double(:user, :user_id => 1) }
  let(:api_key) { double(:api_key, :access_token => "123", :user_id=>1) }

  before(:each) do
    Link.delete_all

    # stub ApiKey model and objects to fake auth token
    allow(ApiKey).to receive(:find_by_access_token) { api_key }
    allow(api_key).to receive(:user) { user }
  end

  describe "GET on /api/v1/links/:id" do
    before(:each) do
      Link.create(
      :link_status => "new",
      :link_url => "http://test.com",
      :link_title => "test title",
      :link_summary => "summary",
      :link_tags => "tag1, tag2"
    )
    end

    it "should return a link by id" do
      link = Link.last
      get "/api/v1/links/#{link.id}"
      expect(last_response).to be_ok
      attributes = JSON.parse(last_response.body)
      expect(attributes["link_url"]).to eq "http://test.com"
    end

    it "should return status of new" do
      link = Link.last
      get "/api/v1/links/#{link.id}"
      expect(last_response).to be_ok
      attributes = JSON.parse(last_response.body)
      expect(attributes["link_status"]).to eq "new"
    end

    it "should return the correct url" do
      link = Link.last
      get "/api/v1/links/#{link.id}"
      expect(last_response).to be_ok
      attributes = JSON.parse(last_response.body)
      expect(attributes["link_url"]).to eq "http://test.com"
    end

    it "should return a 404 for an id that doesn't exist" do
      get '/api/v1/users/3432'
      expect(last_response.status).to eq 404
    end
  end

  describe "POST on /api/v1/links" do
    it "should create a link entry" do
      link_data = {
        :link_status => "new",
        :link_url => "http://test-post.com",
        :link_title => "test post title",
        :link_summary => "summary post",
        :link_tags => "post-tag1, post-tag2"
      }
      post '/api/v1/links', link_data.to_json
      expect(last_response).to be_ok
      link = Link.last
      get "/api/v1/links/#{link.id}"
      attributes = JSON.parse(last_response.body)
      expect(attributes["link_url"]).to eq link_data[:link_url]
      expect(attributes["link_status"]).to eq link_data[:link_status]
    end
  end

  describe "DELETE on /api/v1/links/:id" do
    it "should delete a link" do
      Link.create(
        :link_status => "new",
        :link_url => "http://test.com/delete",
        :link_title => "test title",
        :link_summary => "summary",
        :link_tags => "tag1, tag2"
      )
      link = Link.last
      delete "/api/v1/links/#{link.id}"
      expect(last_response).to be_ok
      get "/api/v1/links/#{link.id}"
      expect(last_response.status).to eq 404
    end

    it "should return 404 if the link to be deleted is not found" do
      delete "/api/v1/links/3242"
      expect(last_response.status).to eq 404
    end
  end

  describe "Get on /api/v1/users/:access_token" do
    let(:random_slug) { ('a'..'z').to_a.shuffle[0,8].join }
    let(:user) { User.create(:user_login=>random_slug) }
    let(:api_key) { ApiKey.create(:user_id=>user.user_id) }


    it "should return a user with access_token" do
      get "/api/v1/users/#{api_key['access_token']}"
      expect(last_response).to be_ok
      attributes = JSON.parse(last_response.body)
      expect(attributes["user_id"].to_s).to eq "#{user[:user_id]}"
    end
  end
end
require 'typhoeus'
require 'json'


class Link
  class << self; attr_accessor :base_uri, :access_token end

  def self.find_by_id(id)
    response = Typhoeus::Request.get("#{base_uri}/api/v1/links/#{id}", :headers => {'Authorization'=> "Bearer #{access_token}"})
    if response.code == 200
      JSON.parse(response.body)
    elsif response.code == 404
      nil
    else
      raise response.body
    end
  end

  def self.create (attributes)
    response = Typhoeus::Request.post("#{base_uri}/api/v1/links", :headers => {'Authorization'=> "Bearer #{access_token}"}, :body => attributes.to_json )
    if response.code == 200
      JSON.parse(response.body)
    elsif response.code == 400
      nil
    else
      raise response.body
    end
  end

  # def self.update(name, attributes)
  #   response = Typhoeus::Request.put("#{base_uri}/api/v1/users/#{name}", :body => attributes.to_json)
  #   if response.code == 200
  #     JSON.parse(response.body)
  #   elsif response.code == 400 || response.code == 404
  #     nil
  #   else
  #     raise response.body
  #   end
  # end

  def self.destroy(id)
    response = Typhoeus::Request.delete("#{base_uri}/api/v1/links/#{id}", :headers => {'Authorization'=> "Bearer #{access_token}"})
    response.success? # response.code == 200
  end

  def self.user
    response = Typhoeus::Request.get("#{base_uri}/api/v1/users/#{access_token}", :headers => {'Authorization'=> "Bearer #{access_token}"})
    if response.code == 200
      JSON.parse(response.body)
    elsif response.code == 404
      nil
    else
      raise response.body
    end
  end
end
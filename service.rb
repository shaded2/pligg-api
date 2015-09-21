require_relative 'models/link'

#default route
get '/' do
  "hello pligg api world"
end

# get a link by id
get '/api/v1/links/:id' do
  begin
    link = Link.find(params[:id])
    link.to_json
  rescue ActiveRecord::RecordNotFound => e
    error 404, {:error => "link not found"}.to_json # :not_found
  end
end

get '/api/v1/users/:access_token' do
  begin
    user = User.joins(:api_key).where('api_keys.access_token' => params[:access_token]).select('api_keys.access_token, pligg_users.*').first
    if user
      user.to_json
    else
      raise ActiveRecord::RecordNotFound
    end
  rescue ActiveRecord::RecordNotFound => e
    error 404, {:error => "user not found"}.to_json # :not_found
  end
end

# create a new link
post '/api/v1/links' do
  begin
    link = Link.create(JSON.parse(request.body.read))
    if link.valid?
      link.to_json
    else
      error 400, link.errors.to_json # :bad_request
    end
  rescue StandardError => e
    error 500, {:error => e.message}.to_json
  end
end

# destroy an existing link
delete '/api/v1/links/:id' do
  begin
    link = Link.find(params[:id])
    link.destroy
    link.to_json
  rescue ActiveRecord::RecordNotFound => e
    error 404, {:error => 'link not found'}.to_json
  rescue StandardError => e
    error 500, {:error => e.message}.to_json
  end
end
require 'faraday'
require 'json'
require 'hashie'

class Gister
  API_URL = "https://api.github.com/"
  #Gister.public_gists => [Gist<Gist#1232>, Gist<Gist#234>]
  def self.public_gists
    response_string = get_response_body("/gists")
    response_json = convert_response_to_json(response_string)
    responses = []
    response_json.each do |response|
      responses << convert_response_to_object(response) # convert response data into a collection of objects
    end
    responses
  end
  
  def self.get_gist(gist_id)
    response_string = get_response_body("/gists/#{gist_id}")
    response_json = convert_response_to_json(response_string)
    convert_response_to_object(response_json)
  end
  
  def self.get_gists_for_user(login)
    response_string = get_response_body("/users/#{login}/gists")
    response_json = convert_response_to_json(response_string)
    responses = []
    response_json.each do |response|
      responses << convert_response_to_object(response) # convert response data into a collection of objects
    end
    responses
  end
  
  private
  
  def self.get_response_body(path)
    connection = Faraday.new :url => API_URL
    response = connection.get path
    response.body
  end
  
  def self.convert_response_to_object(response_json)
    Hashie::Mash.new response_json
  end
  
  def self.convert_response_to_json(response_string)
    JSON.parse(response_string)
  end
end
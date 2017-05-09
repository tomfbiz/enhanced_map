defmodule EnhancedMap.Factory do
  use ExMachina.Ecto, repo: EnhancedMap.Repo
  
  def user_factory do
    %EnhancedMap.User{
      name: "Joe Smith",
      encrypted_password: "encryped",
      email: sequence(:email, &"email-#{&1}@example.com")
    }
  end
  def map_factory do
    %EnhancedMap.Map{
      center_lat: "120.5", 
      center_long: "120.5", 
      description: "some content", 
      overlay_east: "120.5", 
      overlay_north: "120.5", 
      overlay_south: "120.5", 
      overlay_west: "120.5", 
      overlay_URL: "http://url.com",
      title: "Map of this place",
      zoom: 17,
      marker_URL: "http://marker.com"
    }
  end
  
  def marker_factory do
    %EnhancedMap.Marker{
      img_URL: "http://someurl.com", 
      lat: "120.5", 
      long: "120.5", 
      name: "Place",
      text: "this is a cool place",
      map: build(:map)
    }
  end

  def user_factory do
    %EnhancedMap.User{
      name: "Joe Test",
    }
  end
end

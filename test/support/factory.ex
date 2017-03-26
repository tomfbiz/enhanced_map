defmodule EnhancedMap.Factory do
  use ExMachina.Ecto, repo: EnhancedMap.Repo
  
  def user_factory do
    %EnhancedMap.User{
      name: "Joe Smith",
      encrypted_password: "encryped",
      email: sequence(:email, &"email-#{&1}@example.com")
    }
  end
end

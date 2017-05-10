defmodule EnhancedMap.UserTest do
  use EnhancedMap.ModelCase
  import EnhancedMap.Factory


  alias EnhancedMap.User

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, params_for(:user))
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, params_for(:user, email: nil))
    refute changeset.valid?
  end
end

defmodule EnhancedMap.MapTest do
  use EnhancedMap.ModelCase

  alias EnhancedMap.Map
  import EnhancedMap.Factory

 @invalid_attrs %{}

  test "changeset with valid attributes" do
    user = insert(:user)
    changeset = Map.changeset(%Map{}, params_for(:map, user: user))
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Map.changeset(%Map{}, @invalid_attrs)
    refute changeset.valid?
  end
end

defmodule EnhancedMap.MapTest do
  use EnhancedMap.ModelCase

  alias EnhancedMap.Map
  import EnhancedMap.Factory

 @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Map.changeset(%Map{}, string_params_for(:map))
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Map.changeset(%Map{}, @invalid_attrs)
    refute changeset.valid?
  end
end

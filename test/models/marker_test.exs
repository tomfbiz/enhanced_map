defmodule EnhancedMap.MarkerTest do
  use EnhancedMap.ModelCase

  alias EnhancedMap.Marker
  import EnhancedMap.Factory

  @invalid_attrs %{}

  test "changeset with valid attributes" do
    map = insert(:map)
    changeset = Marker.changeset(%Marker{}, params_for(:marker, map: map))
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Marker.changeset(%Marker{}, @invalid_attrs)
    refute changeset.valid?
  end
end

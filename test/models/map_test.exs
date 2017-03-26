defmodule EnhancedMap.MapTest do
  use EnhancedMap.ModelCase

  alias EnhancedMap.Map

  @valid_attrs %{center_lat: "120.5", center_long: "120.5", description: "some content", overlay_east: "120.5", overlay_north: "120.5", overlay_south: "120.5", overlay_west: "120.5", ovetrlay_URL: "some content", title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Map.changeset(%Map{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Map.changeset(%Map{}, @invalid_attrs)
    refute changeset.valid?
  end
end

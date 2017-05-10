defmodule EnhancedMap.Map do
  use EnhancedMap.Web, :model

  schema "maps" do
    field :title, :string
    field :description, :string
    field :center_lat, :decimal
    field :center_long, :decimal
    field :overlay_URL, :string
    field :overlay_north, :decimal
    field :overlay_south, :decimal
    field :overlay_east, :decimal
    field :overlay_west, :decimal
    field :zoom, :integer
    field :marker_URL, :string
    belongs_to :user, Enhancedmap.User
    has_many :markers, EnhancedMap.Marker
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :description, :center_lat, 
                    :center_long, :overlay_URL, 
                    :overlay_north, :overlay_south, 
                    :overlay_east, :overlay_west,
                    :zoom, :marker_URL, :user_id])
    |> validate_required([:title, :description, 
                          :center_lat, :center_long, 
                          :overlay_URL, 
                          :overlay_north, :overlay_south, 
                          :overlay_east, :overlay_west,
                          :zoom, :marker_URL, :user_id])
  end
end

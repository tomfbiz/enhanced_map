defmodule EnhancedMap.Marker do
  use EnhancedMap.Web, :model
  @derive {Poison.Encoder, only: [:id, :name, :img_URL, :text, :lat, :long]}

  schema "markers" do
    field :name, :string
    field :img_URL, :string
    field :text, :string
    field :lat, :decimal
    field :long, :decimal
    belongs_to :map, EnhancedMap.Map

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :img_URL, :text, :lat, :long, :map_id])
    |> validate_required([:name, :img_URL, :text, :lat, :long, :map_id])
  end
end

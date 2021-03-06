defmodule EnhancedMap.User do
  use EnhancedMap.Web, :model

  schema "users" do
    field :name, :string
    field :email, :string
    field :encrypted_password, :string
    has_many :users, EnhancedMap.User
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :email, :encrypted_password])
    |> validate_required([:name, :email, :encrypted_password])
  end
end

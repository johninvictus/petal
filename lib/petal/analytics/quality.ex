defmodule Petal.Analytics.Quality do
  use Ecto.Schema
  import Ecto.Changeset

  schema "qualities" do
    field :name, :string
    field :quality, :integer

    timestamps()
  end

  @doc false
  def changeset(quality, attrs) do
    quality
    |> cast(attrs, [:name, :quality])
    |> validate_required([:name, :quality])
    |> validate_length(:name, min: 2, max: 100)
    |> validate_number(:quality, greater_than: 0, less_than_or_equal_to: 100)
  end
end

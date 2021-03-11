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
    |> capitalize_first_letter_of_name()
  end

  defp capitalize_first_letter_of_name(
         %Ecto.Changeset{valid?: true, changes: %{name: name}} = changeset
       ) do
    put_change(changeset, :name, String.capitalize(name))
  end

  defp capitalize_first_letter_of_name(changeset), do: changeset
end

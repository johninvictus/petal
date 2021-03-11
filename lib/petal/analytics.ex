defmodule Petal.Analytics do
  @moduledoc """
  The Analytics context.
  """

  import Ecto.Query, warn: false
  alias Petal.Repo

  alias Petal.Analytics.Quality

  @analytic_topic "quality_topic"

  def subscribe do
    Phoenix.PubSub.subscribe(Petal.PubSub, @analytic_topic)
  end

  @doc """
  Returns the list of qualities.

  ## Examples

      iex> list_qualities()
      [%Quality{}, ...]

  """
  def list_qualities do
    Repo.all(Quality)
  end

  @doc """
  Gets a single quality.

  Raises `Ecto.NoResultsError` if the Quality does not exist.

  ## Examples

      iex> get_quality!(123)
      %Quality{}

      iex> get_quality!(456)
      ** (Ecto.NoResultsError)

  """
  def get_quality!(id), do: Repo.get!(Quality, id)

  @doc """
  Creates a quality.

  ## Examples

      iex> create_quality(%{field: value})
      {:ok, %Quality{}}

      iex> create_quality(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_quality(attrs \\ %{}) do
    %Quality{}
    |> Quality.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:quality_created)
  end

  @doc """
  Updates a quality.

  ## Examples

      iex> update_quality(quality, %{field: new_value})
      {:ok, %Quality{}}

      iex> update_quality(quality, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_quality(%Quality{} = quality, attrs) do
    quality
    |> Quality.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a quality.

  ## Examples

      iex> delete_quality(quality)
      {:ok, %Quality{}}

      iex> delete_quality(quality)
      {:error, %Ecto.Changeset{}}

  """
  def delete_quality(%Quality{} = quality) do
    Repo.delete(quality)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking quality changes.

  ## Examples

      iex> change_quality(quality)
      %Ecto.Changeset{data: %Quality{}}

  """
  def change_quality(%Quality{} = quality, attrs \\ %{}) do
    Quality.changeset(quality, attrs)
  end

  @doc "Will broadcast success events"
  def broadcast({:ok, quality} = data, event) do
    Phoenix.PubSub.broadcast(
      Petal.PubSub,
      @analytic_topic,
      {event, quality}
    )

    data
  end

  def broadcast({:error, _} = error, _event), do: error
end

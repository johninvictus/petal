defmodule Petal.AnalyticsTest do
  use Petal.DataCase

  alias Petal.Analytics

  describe "qualities" do
    alias Petal.Analytics.Quality

    @valid_attrs %{name: "some name", quality: 42}
    @update_attrs %{name: "some updated name", quality: 43}
    @invalid_attrs %{name: nil, quality: nil}

    def quality_fixture(attrs \\ %{}) do
      {:ok, quality} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Analytics.create_quality()

      quality
    end

    test "list_qualities/0 returns all qualities" do
      quality = quality_fixture()
      assert Analytics.list_qualities() == [quality]
    end

    test "get_quality!/1 returns the quality with given id" do
      quality = quality_fixture()
      assert Analytics.get_quality!(quality.id) == quality
    end

    test "create_quality/1 with valid data creates a quality" do
      assert {:ok, %Quality{} = quality} = Analytics.create_quality(@valid_attrs)
      assert quality.name == "some name"
      assert quality.quality == 42
    end

    test "create_quality/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Analytics.create_quality(@invalid_attrs)
    end

    test "update_quality/2 with valid data updates the quality" do
      quality = quality_fixture()
      assert {:ok, %Quality{} = quality} = Analytics.update_quality(quality, @update_attrs)
      assert quality.name == "some updated name"
      assert quality.quality == 43
    end

    test "update_quality/2 with invalid data returns error changeset" do
      quality = quality_fixture()
      assert {:error, %Ecto.Changeset{}} = Analytics.update_quality(quality, @invalid_attrs)
      assert quality == Analytics.get_quality!(quality.id)
    end

    test "delete_quality/1 deletes the quality" do
      quality = quality_fixture()
      assert {:ok, %Quality{}} = Analytics.delete_quality(quality)
      assert_raise Ecto.NoResultsError, fn -> Analytics.get_quality!(quality.id) end
    end

    test "change_quality/1 returns a quality changeset" do
      quality = quality_fixture()
      assert %Ecto.Changeset{} = Analytics.change_quality(quality)
    end
  end
end

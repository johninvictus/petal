defmodule PetalWeb.AnalyticsLive do
  use PetalWeb, :live_view

  alias Petal.Analytics

  def mount(_params, _session, socket) do
    if connected?(socket), do: Analytics.subscribe()

    qualities = Analytics.list_qualities()
    changeset = Analytics.change_quality(%Analytics.Quality{})

    socket =
      assign(socket,
        qualities: qualities,
        changeset: changeset
      )
      |> push_event("points", %{points: get_data_points(qualities)})

    # temporary_assigns: [qualities: []]
    {:ok, socket}
  end

  def handle_event("save", %{"quality" => params}, socket) do
    case Analytics.create_quality(params) do
      {:ok, _quantity} ->
        changeset = Analytics.change_quality(%Analytics.Quality{})
        socket = assign(socket, changeset: changeset)

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        socket = assign(socket, changeset: changeset)
        {:noreply, socket}
    end
  end

  @doc "This is from the live event, pubsub"
  def handle_info({:quality_created, quality}, socket) do
    socket =
      update(
        socket,
        :qualities,
        fn qualities -> [quality | qualities] end
      )

    {:noreply, push_event(socket,
      "points",
      %{points: get_data_points(socket.assigns.qualities)}
    )}
  end

  defp get_data_points([]), do: 0

  defp get_data_points(qualities) do
    total_count = Enum.reduce(qualities, 0, &(&1.quality + &2))

    ai_p = get_range_quality_pacentage(qualities, ?A..?I, total_count)
    jr_p = get_range_quality_pacentage(qualities, ?J..?R, total_count)
    sz_p = get_range_quality_pacentage(qualities, ?S..?Z, total_count)

    [ai_p, jr_p, sz_p]
  end

  defp get_range_quality_pacentage(qualities, range, total) do
    range_quality =
      qualities
      |> Enum.filter(fn quality ->
        quality.name
        |> to_charlist()
        |> Enum.at(0)
        |> Kernel.in(range)
      end)
      |> Enum.reduce(0, &(&1.quality + &2))

    (range_quality / total * 100)
    |> :math.floor()
  end
end

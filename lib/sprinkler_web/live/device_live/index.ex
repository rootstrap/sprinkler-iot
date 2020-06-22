defmodule SprinklerWeb.DeviceLive.Index do
  use SprinklerWeb, :live_view

  alias Sprinkler.Devices
  alias Sprinkler.Devices.Device

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :devices, list_devices())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Device")
    |> assign(:device, Devices.get_device!(id))
  end

  defp random_string do
    :crypto.strong_rand_bytes(16)
    |> Base.encode64()
    |> binary_part(0, 16)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Device")
    |> assign(:device, %Device{client_id: random_string, secret: random_string})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Devices")
    |> assign(:device, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    device = Devices.get_device!(id)
    {:ok, _} = Devices.delete_device(device)

    {:noreply, assign(socket, :devices, list_devices())}
  end

  defp list_devices do
    Devices.list_devices()
  end
end

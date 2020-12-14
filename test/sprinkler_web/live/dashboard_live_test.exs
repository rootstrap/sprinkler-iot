defmodule SprinklerWeb.DashboardLiveTest do
  use SprinklerWeb.ConnCase

  import Phoenix.LiveViewTest
  alias Sprinkler.Devices

  @telemetry_topic "telemetry"

  @device_with_one_reading %{
    id: 1,
    tmps: [{5, DateTime.utc_now()}],
    hum: [{2, DateTime.utc_now()}],
    moist: [{3, DateTime.utc_now()}],
    irrigations: []
  }
  @device_with_two_readings %{
    id: 1,
    tmps: [{24, DateTime.utc_now()}, {5, DateTime.utc_now()}],
    hum: [{6, DateTime.utc_now()}, {7, DateTime.utc_now()}],
    moist: [{3, DateTime.utc_now()}, {9, DateTime.utc_now()}],
    irrigations: []
  }

  @valid_attrs %{client_id: "some client_id", name: "some name", secret: "some secret"}
  @valid_attrs_device1 %{
    id: 1,
    client_id: "some client_id",
    name: "some name",
    secret: "some secret"
  }
  @valid_attrs_device2 %{
    id: 2,
    client_id: "some client_id",
    name: "some name",
    secret: "some secret"
  }

  def device_fixture(attrs \\ %{}) do
    {:ok, device} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Devices.create_device()

    device
  end

  test "connected mount", %{conn: conn} do
    device_fixture(@valid_attrs_device1)
    device_fixture(@valid_attrs_device2)

    {:ok, _page_live, html} = live(conn, "/dashboard")
    assert html =~ "<h3>Sprinkler 1</h3>"
    assert html =~ "<h3>Sprinkler 2</h3>"

    assert render_component(
             SprinklerWeb.MetricsComponent,
             device: @device_with_one_reading
           ) =~ "5"

    assert render_component(
             SprinklerWeb.MetricsComponent,
             device: @device_with_one_reading
           ) =~ "2"

    assert render_component(
             SprinklerWeb.MetricsComponent,
             device: @device_with_one_reading
           ) =~ "3"
  end

  test "handle_info/3 when temp, humidity and soil moisture are received", %{conn: conn} do
    device_fixture(@valid_attrs_device1)
    device_fixture(@valid_attrs_device2)

    {:ok, page_live, _html} = live(conn, "/dashboard")

    send(page_live.pid, %{
      topic: @telemetry_topic,
      event: "new_reading",
      payload: %{payload: %{"tmp" => 24}, device_id: 1}
    })

    assert render_component(
             SprinklerWeb.MetricsComponent,
             device: @device_with_two_readings
           ) =~ "24"

    assert render_component(
             SprinklerWeb.MetricsComponent,
             device: @device_with_two_readings
           ) =~ "6"

    assert render_component(
             SprinklerWeb.MetricsComponent,
             device: @device_with_two_readings
           ) =~ "3"
  end
end

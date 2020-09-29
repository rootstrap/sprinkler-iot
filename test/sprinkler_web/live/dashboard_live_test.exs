defmodule SprinklerWeb.DashboardLiveTest do
  use SprinklerWeb.ConnCase

  import Phoenix.LiveViewTest

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

  test "connected mount", %{conn: conn} do
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

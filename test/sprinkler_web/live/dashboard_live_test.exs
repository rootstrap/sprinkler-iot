defmodule SprinklerWeb.DashboardLiveTest do
  use SprinklerWeb.ConnCase

  import Phoenix.LiveViewTest

  @telemetry_topic "telemetry"

  test "connected mount", %{conn: conn} do
    {:ok, _page_live, html} = live(conn, "/dashboard")
    assert html =~ "<h3>Sprinkler 1</h3>"
    assert html =~ "<h3>Sprinkler 2</h3>"

    assert render_component(SprinklerWeb.TemperatureComponent,
             device: %{id: 1, tmps: [5], hum: [2], moist: [3]}
           ) =~
             "5"

    assert render_component(SprinklerWeb.TemperatureComponent,
             device: %{id: 1, tmps: [5], hum: [2], moist: [3]}
           ) =~
             "2"

    assert render_component(SprinklerWeb.TemperatureComponent,
             device: %{id: 1, tmps: [5], hum: [2], moist: [3]}
           ) =~
             "3"
  end

  test "handle_info/3 when temp, humidity and soil moisture are received", %{conn: conn} do
    {:ok, page_live, _html} = live(conn, "/dashboard")

    send(page_live.pid, %{
      topic: @telemetry_topic,
      event: "new_reading",
      payload: %{payload: %{"tmp" => 24}, device_id: 1}
    })

    assert render_component(SprinklerWeb.TemperatureComponent,
             device: %{id: 1, tmps: [24, 5], hum: [6, 7], moist: [3, 9]}
           ) =~
             "24"

    assert render_component(SprinklerWeb.TemperatureComponent,
             device: %{id: 1, tmps: [24, 5], hum: [6, 8], moist: [3, 7]}
           ) =~
             "6"

    assert render_component(SprinklerWeb.TemperatureComponent,
             device: %{id: 1, tmps: [24, 5], hum: [2, 6], moist: [3, 7]}
           ) =~
             "3"
  end
end

defmodule SprinklerWeb.TemperatureLiveTest do
  use SprinklerWeb.ConnCase

  import Phoenix.LiveViewTest

  @telemetry "telemetry"

  test "handle_info/2 when temp is received", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/temperature")
    assert disconnected_html =~ "Unknown"
    assert render(page_live) =~ "Unknown"
    send(page_live.pid, %{topic: @telemetry, temp: "25"})
    assert render(page_live) =~ "Temp is: 25"
  end
end

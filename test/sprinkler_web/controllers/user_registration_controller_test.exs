defmodule SprinklerWeb.UserRegistrationControllerTest do
  use SprinklerWeb.ConnCase, async: true

  import Sprinkler.UsersFixtures
  alias Sprinkler.Devices

  @create_attrs %{client_id: "some client_id", name: "some name", secret: "some secret"}
  @attrs_device1 %{id: 1, client_id: "some client_id", name: "some name", secret: "some secret"}
  @attrs_device2 %{id: 2, client_id: "some client_id", name: "some name", secret: "some secret"}

  def fixture(attrs \\ %{}) do
    {:ok, device} =
      attrs
      |> Enum.into(@create_attrs)
      |> Devices.create_device()

    device
  end

  defp create_devices(_) do
    device_1 = fixture(@attrs_device1)
    device_2 = fixture(@attrs_device2)
    %{device_1: device_1, device_2: device_2}
  end

  describe "GET /users/register" do
    test "renders registration page", %{conn: conn} do
      conn = get(conn, Routes.user_registration_path(conn, :new))
      response = html_response(conn, 200)
      assert response =~ "<h1>Register</h1>"
      assert response =~ "Log in</a>"
      assert response =~ "Register</a>"
    end

    test "redirects if already logged in", %{conn: conn} do
      conn = conn |> log_in_user(user_fixture()) |> get(Routes.user_registration_path(conn, :new))
      assert redirected_to(conn) == "/"
    end
  end

  describe "POST /users/register" do
    setup [:create_devices]

    @tag :capture_log
    test "creates account and logs the user in", %{conn: conn} do
      email = unique_user_email()

      conn =
        post(conn, Routes.user_registration_path(conn, :create), %{
          "user" => %{"email" => email, "password" => valid_user_password()}
        })

      assert get_session(conn, :user_token)
      assert redirected_to(conn) =~ "/"

      # Now do a logged in request and assert on the menu
      conn = get(conn, "/")
      response = html_response(conn, 200)
      assert response =~ email
      assert response =~ "Settings</a>"
      assert response =~ "Log out</a>"
    end

    test "render errors for invalid data", %{conn: conn} do
      conn =
        post(conn, Routes.user_registration_path(conn, :create), %{
          "user" => %{"email" => "with spaces", "password" => "too short"}
        })

      response = html_response(conn, 200)
      assert response =~ "<h1>Register</h1>"
      assert response =~ "must have the @ sign and no spaces"
      assert response =~ "should be at least 12 character"
    end
  end
end

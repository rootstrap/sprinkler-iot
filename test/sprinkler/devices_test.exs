defmodule Sprinkler.DevicesTest do
  use Sprinkler.DataCase

  alias Sprinkler.Devices

  describe "devices" do
    alias Sprinkler.Devices.Device

    @valid_attrs %{client_id: "some client_id", name: "some name", secret: "some secret"}
    @update_attrs %{
      client_id: "some updated client_id",
      name: "some updated name",
      secret: "some updated secret"
    }
    @invalid_attrs %{client_id: nil, name: nil, secret: nil}

    def device_fixture(attrs \\ %{}) do
      {:ok, device} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Devices.create_device()

      device
    end

    test "list_devices/0 returns all devices" do
      device = device_fixture()
      assert Devices.list_devices() == [device]
    end

    test "get_device!/1 returns the device with given id" do
      device = device_fixture()
      assert Devices.get_device!(device.id) == device
    end

    test "get_device!/1 returns the device with given id when it exists" do
      device = device_fixture()
      assert Devices.get_device(device.id) == device
    end

    test "get_device!/1 returns nil when the device doesn't exist" do
      assert is_nil(Devices.get_device(1))
    end

    test "create_device/1 with valid data creates a device" do
      assert {:ok, %Device{} = device} = Devices.create_device(@valid_attrs)
      assert device.client_id == "some client_id"
      assert device.name == "some name"
      assert device.secret == "some secret"
    end

    test "create_device/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Devices.create_device(@invalid_attrs)
    end

    test "update_device/2 with valid data updates the device" do
      device = device_fixture()
      assert {:ok, %Device{} = device} = Devices.update_device(device, @update_attrs)
      assert device.client_id == "some updated client_id"
      assert device.name == "some updated name"
      assert device.secret == "some updated secret"
    end

    test "update_device/2 with invalid data returns error changeset" do
      device = device_fixture()
      assert {:error, %Ecto.Changeset{}} = Devices.update_device(device, @invalid_attrs)
      assert device == Devices.get_device!(device.id)
    end

    test "delete_device/1 deletes the device" do
      device = device_fixture()
      assert {:ok, %Device{}} = Devices.delete_device(device)
      assert_raise Ecto.NoResultsError, fn -> Devices.get_device!(device.id) end
    end

    test "change_device/1 returns a device changeset" do
      device = device_fixture()
      assert %Ecto.Changeset{} = Devices.change_device(device)
    end
  end

  describe "readings" do
    alias Sprinkler.Devices
    alias Sprinkler.Devices.GardenReading

    test "new_garden_reading/1 returns a correct %GardenReading with correct attributes" do
      assert %GardenReading{temperature: 10, humidity: 50, moisture: 70} =
               Devices.new_garden_reading(%{
                 temperature: 10,
                 humidity: 50,
                 moisture: 70
               })
    end

    test "new_garden_reading/1 returns an empty %GardenReading with incorrect attributes" do
      assert %GardenReading{temperature: nil, humidity: nil, moisture: nil} =
               Devices.new_garden_reading(%{
                 "temperature" => 10,
                 "humidity" => 50,
                 "moisture" => 70
               })
    end

    test "irrigate_garden/2 calls the callback function with the correct" do
      Devices.irrigate_garden(
        %GardenReading{temperature: 10, humidity: 50, moisture: 10},
        &send(self(), &1)
      )

      assert_received :water_medium
    end
  end
end

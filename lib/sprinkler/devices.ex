defmodule Sprinkler.Devices do
  @moduledoc """
  The Devices context.
  """

  import Ecto.Query, warn: false
  alias Sprinkler.Repo

  alias Sprinkler.Devices.{Device, GardenReading, WateringPolicy}

  @doc """
  Returns the list of devices.

  ## Examples

      iex> list_devices()
      [%Device{}, ...]

  """
  def list_devices do
    Repo.all(Device)
  end

  @doc """
  Gets a single device.

  Raises `Ecto.NoResultsError` if the Device does not exist.

  ## Examples

      iex> get_device!(123)
      %Device{}

      iex> get_device!(456)
      ** (Ecto.NoResultsError)

  """
  def get_device!(id), do: Repo.get!(Device, id)

  @doc """
  Gets a single device.

  Returns nil if the Device does not exist.

  ## Examples

      iex> get_device!(123)
      %Device{}

      iex> get_device!(456)
      nil

  """
  def get_device(id), do: Repo.get(Device, id)

  @doc """
  Creates a device.

  ## Examples

      iex> create_device(%{field: value})
      {:ok, %Device{}}

      iex> create_device(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_device(attrs \\ %{}) do
    %Device{}
    |> Device.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a device.

  ## Examples

      iex> update_device(device, %{field: new_value})
      {:ok, %Device{}}

      iex> update_device(device, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_device(%Device{} = device, attrs) do
    device
    |> Device.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a device.

  ## Examples

      iex> delete_device(device)
      {:ok, %Device{}}

      iex> delete_device(device)
      {:error, %Ecto.Changeset{}}

  """
  def delete_device(%Device{} = device) do
    Repo.delete(device)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking device changes.

  ## Examples

      iex> change_device(device)
      %Ecto.Changeset{data: %Device{}}

  """
  def change_device(%Device{} = device, attrs \\ %{}) do
    Device.changeset(device, attrs)
  end

  @doc """
  Create a new %GardenReading from a map

  ## Examples

      iex> new_garden_reading()
      %GardenReading{}
  """
  def new_garden_reading(params \\ %{}) do
    struct(GardenReading, params)
  end

  @doc """
  Calls the irrigate callback with the amount to irrigate
  """
  def irrigate_garden(%GardenReading{} = reading, irrigate) when is_function(irrigate, 1) do
    reading
    |> WateringPolicy.irrigation_amount()
    |> irrigate.()
  end

  def irrigate_garden(_, _), do: nil
end

defmodule Grid do
  @moduledoc """
  Grid provides easy generation and manipulation
  of two dimensional lists.
  """
  defstruct width: 0,
            height: 0,
            data: %{}

  @doc """
  Generate a new grid with a default value or from a list.
  Returns a map
  """
  @spec create(integer(), integer(), any()) :: %__MODULE__{}
  def create(width, height, default \\ nil) when width > 0 and height > 0 do
    data = for x <- 0..(width - 1), y <- 0..(height - 1), into: %{}, do: {{x, y}, default}
    %__MODULE__{width: width, height: height, data: data}
  end

  @spec create(list(list())) :: %__MODULE__{}
  def create(data) do
    width = length(data)
    height = length(Enum.at(data, 0))

    data_as_map =
      for x <- 0..(width - 1),
          y <- 0..(height - 1),
          into: %{},
          do: {{x, y}, Enum.at(Enum.at(data, y - (height - 1)), x)}

    %__MODULE__{width: width, height: height, data: data_as_map}
  end

  @doc """
  Returns given grid as a string.

  * Rows are separated by newline characters.
  """
  @spec to_string(%__MODULE__{}) :: String.t()
  def to_string(%__MODULE__{} = grid) do
    to_string(0, grid.height - 1, grid, "")
  end

  def to_string(_, -1, _, acc) do
    acc
  end

  def to_string(x, y, %__MODULE__{width: width} = grid, acc) when x >= width do
    to_string(0, y - 1, grid, acc <> "\n")
  end

  def to_string(x, y, grid, acc) do
    value = grid.data[{x, y}]
    to_string(x + 1, y, grid, acc <> inspect(value))
  end
end

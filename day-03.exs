defmodule Day3 do
  @input_file "day-03-input.txt"
  @central_port [0, 0]

  defp get_input do
    {:ok, input} = File.read(@input_file)
    parse_input(input)
  end

  defp parse_input(input) do
    input |> String.split("\n", trim: true)
  end

  defp parse_wire(str) do
    String.split(str, ",", trim: true)
  end

  defp parse_vector(vector) do
    ~r/(?<direction>U|D|L|R)(?<magnitude>\d+)/
    |> Regex.named_captures(vector)
    |> Map.update!("magnitude", &String.to_integer/1) # Magnitude should be an integer
  end

  defp plot_vector(graph, vector) do
    [x, y] = List.last(graph) # Current graph coordinates
    %{ "direction" => direction, "magnitude" => magnitude } = parse_vector(vector)
    
    plotter = fn n ->
      case direction do
        "U" -> [ x, y + n ]
        "D" -> [ x, y - n ]
        "R" -> [ x + n, y ]
        "L" -> [ x - n, y ]
      end
    end

    graph ++ (1..magnitude |> Enum.map(plotter))
  end

  defp plot_path(path) do
    graph = [@central_port] # Begin at the central port
    Enum.reduce(path, graph, fn vector, acc -> plot_vector(acc, vector) end)
  end

  defp plot_wire(wire) do
    wire
    |> parse_wire()
    |> plot_path()
  end

  defp distance_from_central_port(coords) do
    # Manhattan Distance is |x1 - x2| + |y1 - y2|
    [x1, y1] = @central_port
    [x2, y2] = coords
    abs(x2 - x1) + abs(y2 - y1)
  end

  defp find_intersections(graph1, graph2) do
    mapset1 = MapSet.new(graph1) 
    mapset2 = MapSet.new(graph2)
    MapSet.intersection(mapset1, mapset2)
  end

  def distance_to_closest_intersection(wire1, wire2) do
    graph1 = plot_wire(wire1)
    graph2 = plot_wire(wire2)
    
    find_intersections(graph1, graph2)
    |> MapSet.delete(@central_port) # Don't count the central port as an intersection
    |> Enum.map(&distance_from_central_port/1)
    |> Enum.min
  end

  def part1 do
    [wire1, wire2] = get_input()
    distance_to_closest_intersection(wire1, wire2)
  end
end

IO.puts "Part 1: #{Day3.part1}"

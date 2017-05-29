defmodule NhaccuatuiCli do
  @topnhacviet "http://www.nhaccuatui.com/ajax/get-top-20?type=&genre=nhac-viet&isHome=true"
  @topnhacus "http://www.nhaccuatui.com/ajax/get-top-20?type=&genre=au-my&isHome=true"
  @topnhachan "http://www.nhaccuatui.com/ajax/get-top-20?type=&genre=nhac-han&isHome=true"
  @search_url "http://www.nhaccuatui.com/ajax/search?"

  def main(args) do
    options = parse_args(args)
    case Keyword.get(options, :action) do
      "top-vn" -> get_top(@topnhacviet, "Top 10 nhạc Việt")
      "top-us" -> get_top(@topnhacus, "Top 10 nhạc Âu Mỹ")
      "top-kr" -> get_top(@topnhachan, "Top 10 nhạc Hàn")
      "search" -> search(Keyword.get(options, :query))
      _ -> get_top(@topnhacviet, "Top 10 nhạc Việt")
    end
  end

  def search(query) do
    url = "#{@search_url}q=#{query}"
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        temp = body |> Poison.Parser.parse!

        print_entities(temp["data"]["song"], "songs")
        print_entities(temp["data"]["video"], "videos")
        print_entities(temp["data"]["singer"], "singers")
        print_entities(temp["data"]["playlist"], "playlists")
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end

  defp get_top(url, title) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        temp = body |> Poison.Parser.parse!
        html = temp["data"]["html"]
        tops = Floki.find(html, "a.name_song")

        header = ["Name", "Url"]
        rows = tops |> Enum.map(fn (song) ->
                        [elem(Enum.at(elem(song, 1), 0), 1),
                          elem(Enum.at(elem(song, 1), 1), 1)]
                        end)
        TableRex.quick_render!(rows, header, title) |> IO.puts
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end

  defp parse_args(args) do
    {options, _, _} = OptionParser.parse(args,
      switches: [action: :string]
    )
    options
  end

  defp print_entities(entities, type) do
    header = ["Name", "Url"]
    title = "Search result by #{type}"
    rows = Enum.map(entities, fn (song) -> print_entity(song) end)
    if Enum.any?(rows) do
      TableRex.quick_render!(rows, header, title) |> IO.puts
    end
  end

  defp print_entity(entity) do
    [entity["name"], entity["url"]]
  end
end

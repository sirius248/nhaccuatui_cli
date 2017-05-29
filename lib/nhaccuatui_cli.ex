defmodule NhaccuatuiCli do
  @topnhacviet "http://www.nhaccuatui.com/ajax/get-top-20?type=&genre=nhac-viet&isHome=true"
  @topnhacus "http://www.nhaccuatui.com/ajax/get-top-20?type=&genre=au-my&isHome=true"
  @topnhachan "http://www.nhaccuatui.com/ajax/get-top-20?type=&genre=nhac-han&isHome=true"
  @search_url "http://www.nhaccuatui.com/ajax/search?"

  def main(args) do
    options = parse_args(args)
    case Enum.at(args, 0) do
      "top-vn" -> get_top(@topnhacviet, "Top 10 nhạc Việt")
      "top-us" -> get_top(@topnhacus, "Top 10 nhạc Âu Mỹ")
      "top-kr" -> get_top(@topnhachan, "Top 10 nhạc Hàn")
      "search" -> search(Enum.at(args, 1))
      "play" -> play(Enum.at(args, 1))
      "download" -> download(Enum.at(args, 1), options)
      _ -> IO.puts "No command provided."
    end
  end

  def download(url, options) do
    IO.puts "Downloading #{url}"
    Application.ensure_all_started(:inets)
    output_path = Path.expand(Keyword.get(options, :out, "."))
    {download_url, _} = System.cmd("ruby", [Path.absname("./lib/ruby/scraper.rb"), url])
    download_url = download_url |> String.trim
    file_name = Enum.at(download_url |> String.split("?"), 0) |> String.split("/") |> Enum.reverse |> Enum.take(1) |> Enum.at(0)

    case HTTPoison.get!(download_url) do
      %HTTPoison.Response{headers: headers, status_code: 302} ->
        new_download_url = elem(Enum.at(headers, 0), 1)
        %HTTPoison.Response{body: new_body} = HTTPoison.get!(new_download_url)
        File.write!("#{output_path}/#{file_name}", new_body)
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        File.write!("#{output_path}/#{file_name}", body)
      _ ->
        IO.puts "Download error."
    end
  end

  defp play(uri) do
    System.cmd("open", [uri])
  end

  defp search(query) do
    uri = URI.encode("#{@search_url}q=#{query}")
    case HTTPoison.get(uri) do
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

  defp parse_args(args) do
    {options, _, _} = OptionParser.parse(args,
      switches: [out: :string]
    )
    options
  end
end

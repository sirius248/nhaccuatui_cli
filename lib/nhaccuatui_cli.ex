defmodule NhaccuatuiCli do
  @topnhacviet "http://www.nhaccuatui.com/ajax/get-top-20?type=&genre=nhac-viet&isHome=true"
  @topnhacus "http://www.nhaccuatui.com/ajax/get-top-20?type=&genre=au-my&isHome=true"
  @topnhachan "http://www.nhaccuatui.com/ajax/get-top-20?type=&genre=nhac-han&isHome=true"

  def main(args) do
    options = parse_args(args)
    case Keyword.get(options, :action) do
      "top-vn" -> get_top(@topnhacviet, "Top 10 nhạc Việt")
      "top-us" -> get_top(@topnhacus, "Top 10 nhạc Âu Mỹ")
      "top-kr" -> get_top(@topnhachan, "Top 10 nhạc Hàn")
      _ -> get_top(@topnhacviet, "Top 10 nhạc Việt")
    end
  end

  defp get_top(url, title) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        temp = body |> Poison.Parser.parse!
        html = temp["data"]["html"]
        tops = Floki.find(html, "a.name_song")

        IO.puts "### #{title} ###"
        tops |> Enum.each(fn (song) ->
          title = elem(Enum.at(elem(song, 1), 0), 1)
          url = elem(Enum.at(elem(song, 1), 1), 1)
          IO.puts "#{title} *** #{url}"
        end)
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
end

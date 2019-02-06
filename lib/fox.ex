defmodule Fox do
  def getGists(username) do
    HTTPoison.get!("https://api.github.com/users/" <> username <> "/gists").body
    |> JSON.decode()
    |> Tuple.to_list()
  end

  def getScripts(username) do
    [:ok, gists] = getGists(username)

    gists
    |> Enum.filter(fn e ->
      e
      |> Map.get("files")
      |> Map.values()
      |> hd
      |> Map.get("type") == "application/x-sh"
    end)
    |> Enum.map(fn e ->
      e |> Map.take(["description", "files"])
    end)
  end

  def display(scripts) do
    scripts |> Enum.map(fn e -> IO.puts(Map.get(e, "description")) end)
  end
end

defmodule Bluesky do
  defstruct prefix: nil, data: nil

  @moduledoc """
  Documentation for `Bluesky
  """

  @bluesky_prefix "https://bsky.social/xrpc/"

  defp _get(%__MODULE__{prefix: prefix, data: data}, path, params \\ [], token \\ "accessJwt") do
    url = "#{prefix}#{path}"
    headers = [Authorization: "Bearer #{data[token]}"]
    response = HTTPoison.get!(url, headers, params: params)
    data = Poison.Parser.parse!(response.body)

    if Map.has_key?(data, "error") do
      {:error, data}
    else
      {:ok, data}
    end
  end

  defp _post(%__MODULE__{prefix: prefix, data: data}, path, params, token \\ "accessJwt") do
    url = "#{prefix}#{path}"
    params =
      if is_map(params) do
        Poison.encode!(params)
      else
        params
      end
    headers = [
      "Content-Type": "application/json; charset=UTF-8",
      Authorization: "Bearer #{data[token]}"
    ]

    response = HTTPoison.post!(url, params, headers)

    if response.body == "" do
      {:ok, nil}
    else
      data = Poison.Parser.parse!(response.body)

      if Map.has_key?(data, "error") do
        {:error, data}
      else
        {:ok, data}
      end
    end
  end

  # See Bluesky HTTP API reference
  # https://docs.bsky.app/docs/category/http-reference

  def get_preference(session) do
    _get(session, "app.bsky.actor.getPreferences")
  end

  def get_profile(session, actor) do
    _get(session, "app.bsky.actor.getProfile", actor: actor)
  end

  def put_preferences(session, preferences) do
    _post(session, "app.bsky.actor.putPreferences", %{preferences: preferences})
  end


  def delete_session(session) do
    _post(session, "com.atproto.server.deleteSession", "", "refreshJwt")
  end

  def refresh_session(session) do
    {:ok, result} = _post(session, "com.atproto.server.refreshSession", "", "refreshJwt")
    {:ok, %{session | data: result}}
  end

  @doc """
  Create session.

  ## Examples

      iex> Bluesky.create_session("XXX.bsky.social", "secret")
      {:ok, %Bluesky.Session{...}}
  """
  def create_session(identifier, password, prefix \\ @bluesky_prefix) do
    url = "#{prefix}com.atproto.server.createSession"
    headers = ["Content-Type": "application/json; charset=UTF-8"]
    body = Poison.encode!(%{identifier: identifier, password: password})
    response = HTTPoison.post!(url, body, headers)
    data = Poison.Parser.parse!(response.body)

    ok_error =
      if response.status_code == 200 do
        :ok
      else
        :error
      end

    {ok_error, %__MODULE__{prefix: prefix, data: data}}
  end
end

defmodule BlueskyTest do
  use ExUnit.Case

  @identifier TestHelpers.get_identifier()
  @password TestHelpers.get_password()

  test "session_test" do
    {:ok, session} = Bluesky.create_session(@identifier, @password)

    {:ok, result} = Bluesky.get_preference(session)
    assert Map.keys(result) == ["preferences"]

    {:ok, result} = Bluesky.get_profile(session, @identifier)

    assert Map.keys(result) == [
             "associated",
             "avatar",
             "createdAt",
             "did",
             "displayName",
             "followersCount",
             "followsCount",
             "handle",
             "indexedAt",
             "labels",
             "postsCount",
             "viewer"
           ]

    {:ok, result} =
      Bluesky.put_preferences(session, [
        %{
          "$type": "app.bsky.actor.defs#personalDetailsPref",
          birthDate: "1967-08-11T00:00:00.000Z"
        }
      ])
    assert result == nil
    {:ok, session} = Bluesky.refresh_session(session)

    assert Bluesky.delete_session(session) == {:ok, nil}

  end
end

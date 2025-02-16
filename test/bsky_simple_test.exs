defmodule BlueskySimpleTest do
  use ExUnit.Case

  @identifier TestHelpers.get_identifier()
  @password TestHelpers.get_password()

  test "session_test" do
    {:ok, session} = BskySimple.create_session(@identifier, @password)

    {:ok, result} = BskySimple.get_preference(session)
    assert Map.keys(result) == ["preferences"]

    {:ok, result} = BskySimple.get_profile(session, @identifier)

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
      BskySimple.put_preferences(session, [
        %{
          "$type": "app.bsky.actor.defs#personalDetailsPref",
          birthDate: "1967-08-11T00:00:00.000Z"
        }
      ])
    assert result == nil
    {:ok, session} = BskySimple.refresh_session(session)

    assert BskySimple.delete_session(session) == {:ok, nil}

  end
end

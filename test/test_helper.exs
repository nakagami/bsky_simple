ExUnit.start()

defmodule TestHelpers do
  def get_identifier() do
    System.get_env("BSKY_TEST_IDENTIFIER")
  end

  def get_password() do
    System.get_env("BSKY_TEST_PASWORD")
  end
end

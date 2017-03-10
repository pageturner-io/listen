defmodule Listen.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build and query models.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest

      alias Listen.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      import Listen.Router.Helpers

      # The default endpoint for testing
      @endpoint Listen.Endpoint

      def guardian_login(%Listen.User{} = user), do: guardian_login(build_conn(), user, :token, [])
      def guardian_login(%Listen.User{} = user, token), do: guardian_login(build_conn(), user, token, [])
      def guardian_login(%Listen.User{} = user, token, opts), do: guardian_login(build_conn(), user, token, opts)

      def guardian_login(%Plug.Conn{} = conn, user), do: guardian_login(conn, user, :token, [])
      def guardian_login(%Plug.Conn{} = conn, user, token), do: guardian_login(conn, user, token, [])
      def guardian_login(%Plug.Conn{} = conn, user, token, opts) do
        conn = bypass_through(conn, Listen.Router, [:browser])
          |> get("/")
          |> Guardian.Plug.sign_in(user, token, opts)

        put_resp_cookie(conn, "pageturner_identity", Guardian.Plug.current_token(conn))
          |> send_resp(200, "Flush the session yo")
          |> recycle()
      end
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Listen.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Listen.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end

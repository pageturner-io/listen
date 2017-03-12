defmodule Listen.Web do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use Listen.Web, :controller
      use Listen.Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: Listen.Web

      alias Listen.Repo
      import Ecto
      import Ecto.Query

      import Listen.Web.Router.Helpers
      import Listen.Web.Gettext
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "lib/listen/web/templates",
                        namespace: Listen.Web

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import Listen.Web.Router.Helpers
      import Listen.Web.ErrorHelpers
      import Listen.Web.Gettext
    end
  end

  def router do
    quote do
      use Phoenix.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel

      alias Listen.Repo
      import Ecto
      import Ecto.Query
      import Listen.Web.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end

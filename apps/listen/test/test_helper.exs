{:ok, _} = Application.ensure_all_started(:ex_machina)

hivent = Application.get_env(:listen, :hivent)
hivent.start(nil, nil)

ExUnit.start

Ecto.Adapters.SQL.Sandbox.mode(Listen.Repo, :manual)

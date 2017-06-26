{:ok, _} = Application.ensure_all_started(:ex_machina)

try do
  hivent = Application.get_env(:listen, :hivent)
  hivent.start(nil, nil)
rescue
  _ -> nil
end

ExUnit.start

Ecto.Adapters.SQL.Sandbox.mode(Listen.Repo, :manual)

ExUnit.start()

try do
  hivent = Application.get_env(:listen, :hivent)
  hivent.start(nil, nil)
rescue
  _ -> nil
end

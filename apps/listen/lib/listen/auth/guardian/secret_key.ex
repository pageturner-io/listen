defmodule Listen.Auth.Guardian.SecretKey do
  def fetch do
    System.get_env("GUARDIAN_SECRET_KEY")
  end
end

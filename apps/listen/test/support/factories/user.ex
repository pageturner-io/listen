defmodule Listen.UserFactory do
  defmacro __using__(_opts) do
    quote do
      alias Listen.Accounts.User

      def user_factory do
        %User{
          id: Ecto.UUID.generate(),
          name: "Bob Belcher",
          email: sequence(:email, &"email-#{&1}@example.com")
        }
      end
    end
  end
end

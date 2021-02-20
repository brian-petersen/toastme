defmodule ToastMe.Repo do
  use Ecto.Repo,
    otp_app: :toastme,
    adapter: Ecto.Adapters.Postgres
end

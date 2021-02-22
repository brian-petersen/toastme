defmodule ToastMe.Matches do
  alias ToastMe.Match
  alias ToastMe.Repo

  def create(params) do
    params
    |> Match.changeset()
    |> Repo.insert()
  end
end

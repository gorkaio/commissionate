defmodule Commissionate.Factory do
  use ExMachina.Ecto, repo: Commissionate.Repo

  def merchant_factory do
    %{
      name: sequence(:name, &"Merchant#{&1}"),
      email: sequence(:email, &"email#{&1}@example.com"),
      cif: "A" <> String.pad_leading(sequence(:cif, &"#{&1}"), 7, "0") <> "B"
    }
  end
end

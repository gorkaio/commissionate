defmodule Commissionate.Factory do
  use ExMachina.Ecto, repo: Commissionate.Repo

  def merchant_factory do
    %{
      name: sequence(:name, &"Merchant#{&1}"),
      email: sequence(:email, &"email#{&1}@example.com"),
      cif: "A" <> String.pad_leading(sequence(:cif, &"#{&1}"), 7, "0") <> "B"
    }
  end

  def shopper_factory do
    %{
      name: sequence(:name, &"Shopper#{&1}"),
      email: sequence(:email, &"email#{&1}@example.com"),
      nif: String.pad_leading(sequence(:nif, &"#{&1}"), 8, "0") <> "B"
    }
  end
end

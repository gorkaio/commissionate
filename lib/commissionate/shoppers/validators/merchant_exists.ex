defmodule Commissionate.Shoppers.Validators.MerchantExists do
  use Vex.Validator

  alias Commissionate.Merchants

  def validate(value, _options) do
    Vex.Validators.By.validate(value,
      function: fn value -> merchant_registered?(value) end,
      message: "unregistered merchant"
    )
  end

  defp merchant_registered?(cif) do
    case Merchants.merchant_by_cif(cif) do
      nil -> false
      _ -> true
    end
  end
end

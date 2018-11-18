defmodule Commissionate.Merchants.Validators.UniqueCif do
  use Vex.Validator

  alias Commissionate.Merchants

  def validate(value, _options) do
    Vex.Validators.By.validate(value,
      function: fn value -> !cif_registered?(value) end,
      message: "already taken"
    )
  end

  defp cif_registered?(cif) do
    case Merchants.merchant_by_cif(cif) do
      nil -> false
      _ -> true
    end
  end
end

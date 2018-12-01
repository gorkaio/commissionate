defmodule Commissionate.Shoppers.Validators.UniqueNif do
  use Vex.Validator

  alias Commissionate.Shoppers

  def validate(value, _options) do
    Vex.Validators.By.validate(value,
      function: fn value -> !nif_registered?(value) end,
      message: "already taken"
    )
  end

  defp nif_registered?(nif) do
    case Shoppers.shopper_by_nif(nif) do
      nil -> false
      _ -> true
    end
  end
end

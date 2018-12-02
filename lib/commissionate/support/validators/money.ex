defmodule Commissionate.Support.Validators.Money do
  use Vex.Validator

  def validate(value, _options) do
    Vex.Validators.By.validate(value,
      function: fn value -> money?(value) end,
      message: "invalid amount"
    )
  end

  defp money?(value) when is_integer(value) do
    value > 0
  end

  defp money?(_), do: false
end

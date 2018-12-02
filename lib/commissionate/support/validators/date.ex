defmodule Commissionate.Support.Validators.DateTime do
  use Vex.Validator

  def validate(value, _options) do
    Vex.Validators.By.validate(value,
      function: fn value -> date_time?(value) end,
      message: "invalid date"
    )
  end

  defp date_time?(%DateTime{}) do
    true
  end

  defp date_time?(%Ecto.DateTime{}) do
    true
  end

  defp date_time?(_), do: false
end

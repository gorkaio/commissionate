defmodule Commissionate.Support.Validators.Email do
  use Vex.Validator

  def validate(value, _options) do
    Vex.Validators.By.validate(value,
      function: fn value -> email?(value) end,
      message: "invalid email"
    )
  end

  defp email?(email) when is_binary(email) do
    Regex.run(~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+$/, email) !== nil
  end

  defp email?(_), do: false
end

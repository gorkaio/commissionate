defmodule Commissionate.Support.Validators.Nif do
  use Vex.Validator

  def validate(value, _options) do
    Vex.Validators.By.validate(value,
      function: fn value -> nif?(value) end,
      message: "invalid NIF"
    )
  end

  defp nif?(nif) when is_binary(nif) do
    Regex.run(~r/^[0-9]{8}[A-Z]$/, nif |> String.upcase()) !== nil
  end

  defp nif?(_), do: false
end

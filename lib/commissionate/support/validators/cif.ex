defmodule Commissionate.Support.Validators.Cif do
  use Vex.Validator

  def validate(value, _options) do
    Vex.Validators.By.validate(value,
      function: fn value -> cif?(value) end,
      message: "invalid CIF"
    )
  end

  defp cif?(cif) when is_binary(cif) do
    Regex.run(~r/^[ABCDEFGHKLMNPQS][0-9]{7}[A-Z]$/, cif |> String.upcase()) !== nil
  end

  defp cif?(_), do: false
end

defmodule Commissionate.Support.Validators.Uuid do
  use Vex.Validator

  def validate(value, _options) do
    Vex.Validators.By.validate(value, function: &uuid?/1, allow_nil: false, allow_blank: false)
  end

  defp uuid?(uuid) do
    case UUID.info(uuid) do
      {:ok, _} -> true
      {:error, _} -> false
    end
  end
end

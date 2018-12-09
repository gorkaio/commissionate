defmodule Commissionate.Merchants.Support.PaymentDate do
  def from(%Date{} = date) do
    next_monday(date)
  end

  def from(%DateTime{} = date) do
    date
    |> DateTime.to_date()
    |> from()
  end

  def from(date) when is_binary(date) do
    with {:ok, date, _} <- DateTime.from_iso8601(date) do
      date
      |> DateTime.to_date()
      |> from()
    else
      reply -> reply
    end
  end

  def from(err), do: {:error, :invalid_date, err}

  defp next_monday(%Date{} = date) do
    date
    |> Date.add(7 - Date.day_of_week(date) + 1)
  end
end

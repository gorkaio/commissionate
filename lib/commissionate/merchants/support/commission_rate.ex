defmodule Commissionate.Merchants.Support.CommissionRate do
  @doc """
  Calculates rate for given amount in cents
  @todo: Below 50c, rate is zero. Consider adding some domain logic for this cases or always return a minimun
    rate of 1c. I won't do it here as it is not specified in the challenge.
  """
  def from(amount) when is_integer(amount) and amount >= 0 do
    commission =
      cond do
        amount < 5000 -> amount * 100
        amount >= 5000 and amount <= 30000 -> amount * 95
        amount >= 30000 -> amount * 85
      end

    trunc(Float.round(commission / 10000))
  end

  def from(_), do: 0
end

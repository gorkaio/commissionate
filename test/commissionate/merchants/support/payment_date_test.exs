defmodule Commissionate.Merchants.Support.PaymentDateTest do
  use ExUnit.Case, async: true

  alias Commissionate.Merchants.Support.PaymentDate

  @tag :unit
  test "returns monday next week when given a monday" do
    {:ok, date} = Date.new(2018, 12, 10)
    assert PaymentDate.from(date) == ~D[2018-12-17]
  end

  @tag :unit
  test "returns tomorrow when given a sunday" do
    {:ok, date} = Date.new(2018, 12, 9)
    assert PaymentDate.from(date) == ~D[2018-12-10]
  end
end

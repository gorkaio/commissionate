defmodule Commissionate.Merchants.Support.CommissionRateTest do
  use ExUnit.Case, async: true

  alias Commissionate.Merchants.Support.CommissionRate

  @tag :unit
  test "rate is zero for values below zero" do
    assert CommissionRate.from(-2) == 0
  end

  @tag :unit
  test "rate is zero for value zero" do
    assert CommissionRate.from(0) == 0
  end

  @tag :unit
  test "rate is 1% for values above zero and below 50€" do
    assert CommissionRate.from(1) == 0
    assert CommissionRate.from(10) == 0
    assert CommissionRate.from(50) == 1
    assert CommissionRate.from(100) == 1
    assert CommissionRate.from(3000) == 30
  end

  @tag :unit
  test "rate is 0.95% for values between 50€ and 300€" do
    assert CommissionRate.from(5000) == 48
    assert CommissionRate.from(20000) == 190
    assert CommissionRate.from(30000) == 285
  end

  @tag :unit
  test "rate is 0.85% for values above 300€" do
    assert CommissionRate.from(50000) == 425
  end
end

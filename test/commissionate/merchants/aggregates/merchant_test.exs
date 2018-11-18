defmodule Commissionate.Merchants.Aggregates.MerchantTest do
  use Commissionate.AggregateCase, aggregate: Commissionate.Merchants.Aggregates.Merchant

  alias Commissionate.Merchants.{Commands.Register, Events.Registered}

  describe "register merchant" do
    @tag :unit
    test "should succeed when valid" do
      merchant_uuid = UUID.uuid4()
      {:ok, command} = Register.new(merchant_uuid, "Acme", "acme@example.com", "A2222222B")
      {:ok, event} = Registered.new(merchant_uuid, "Acme", "acme@example.com", "A2222222B")

      assert_events(command, [event])
    end
  end
end

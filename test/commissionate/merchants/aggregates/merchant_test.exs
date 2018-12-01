defmodule Commissionate.Merchants.Aggregates.MerchantTest do
  use Commissionate.AggregateCase, aggregate: Commissionate.Merchants.Aggregates.Merchant

  alias Commissionate.Merchants.{Commands.Register, Events.Registered}

  describe "register merchant" do
    @tag :unit
    test "should succeed when valid" do
      merchant_uuid = UUID.uuid4()

      assert_events(
        Register.new(%{"id" => merchant_uuid, "name" => "Acme", "email" => "acme@example.com", "cif" => "A2222222B"}),
        [
          Registered.new(%{"id" => merchant_uuid, "name" => "Acme", "email" => "acme@example.com", "cif" => "A2222222B"})
        ]
      )
    end
  end
end

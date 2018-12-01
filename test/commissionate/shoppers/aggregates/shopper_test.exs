defmodule Commissionate.Shoppers.Aggregates.ShopperTest do
  use Commissionate.AggregateCase, aggregate: Commissionate.Shoppers.Aggregates.Shopper

  alias Commissionate.Shoppers.{Commands.Register, Events.Registered}

  describe "register shopper" do
    @tag :unit
    test "should succeed when valid" do
      shopper_uuid = UUID.uuid4()
      {:ok, command} = Register.new(shopper_uuid, "Alice", "alice@example.com", "11111111H")
      {:ok, event} = Registered.new(shopper_uuid, "Alice", "alice@example.com", "11111111H")

      assert_events(command, [event])
    end
  end
end

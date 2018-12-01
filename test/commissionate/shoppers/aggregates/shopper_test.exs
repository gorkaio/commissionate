defmodule Commissionate.Shoppers.Aggregates.ShopperTest do
  use Commissionate.AggregateCase, aggregate: Commissionate.Shoppers.Aggregates.Shopper

  alias Commissionate.Shoppers.{Commands.Register, Events.Registered}

  describe "register shopper" do
    @tag :unit
    test "should succeed when valid" do
      shopper_uuid = UUID.uuid4()

      assert_events(
        Register.new(%{"id" => shopper_uuid, "name" => "Alice", "email" => "alice@example.com", "nif" => "11111111H"}),
        [
          Registered.new(%{
            "id" => shopper_uuid,
            "name" => "Alice",
            "email" => "alice@example.com",
            "nif" => "11111111H"
          })
        ]
      )
    end
  end
end

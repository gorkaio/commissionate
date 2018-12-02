defmodule Commissionate.Shoppers.Aggregates.ShopperTest do
  use Commissionate.AggregateCase, aggregate: Commissionate.Shoppers.Aggregates.Shopper

  alias Commissionate.Shoppers.Commands.{Register, PlaceOrder}
  alias Commissionate.Shoppers.Events.{Registered, OrderPlaced}

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

  describe "place an order" do
    @tag :unit
    test "should succeed when valid" do
      shopper_uuid = UUID.uuid4()
      order_id = UUID.uuid4()
      purchase_date = Ecto.DateTime.utc()
      amount = 23
      merchant_cif = "A8888888B"
      nif = "11111111H"

      assert_events(
        [
          Registered.new(%{
            "id" => shopper_uuid,
            "name" => "Alice",
            "email" => "alice@example.com",
            "nif" => nif
          })
        ],
        PlaceOrder.new(%{
          "id" => shopper_uuid,
          "order_id" => order_id,
          "merchant_cif" => merchant_cif,
          "amount" => amount,
          "purchase_date" => purchase_date
        }),
        [
          OrderPlaced.new(%{
            "id" => shopper_uuid,
            "order_id" => order_id,
            "shopper_nif" => nif,
            "merchant_cif" => merchant_cif,
            "amount" => amount,
            "purchase_date" => purchase_date
          })
        ]
      )
    end
  end
end

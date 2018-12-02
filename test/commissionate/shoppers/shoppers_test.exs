defmodule Commissionate.ShoppersTest do
  use Commissionate.DataCase

  alias Commissionate.{Shoppers, Merchants}
  alias Commissionate.Shoppers.Projections.Shopper
  alias Commissionate.Merchants.Projections.Merchant

  @valid_name "Alice"
  @valid_email "alice@example.com"
  @valid_nif "11111111H"

  describe "register shopper" do
    @tag :integration
    test "should succeed with valid data" do
      assert {:ok, %Shopper{} = shopper} = Shoppers.register_shopper(@valid_name, @valid_email, @valid_nif)
      assert shopper.name == @valid_name
      assert shopper.email == @valid_email
      assert shopper.nif == @valid_nif
    end

    @tag :integration
    test "should error with invalid data" do
      assert {:error, :validation_failure, %{name: ["can't be empty", "Invalid name"]}} =
               Shoppers.register_shopper("", @valid_email, @valid_nif)

      assert {:error, :validation_failure, %{email: ["can't be empty", "invalid email"]}} =
               Shoppers.register_shopper(@valid_name, "", @valid_nif)

      assert {:error, :validation_failure, %{nif: ["can't be empty", "invalid NIF"]}} =
               Shoppers.register_shopper(@valid_name, @valid_email, "")
    end

    @tag :integration
    test "should fail when registering identical nif at same time and return error" do
      shopper = build(:shopper, nif: "INVALID")

      1..2
      |> Enum.map(fn _ -> Task.async(fn -> Shoppers.register_shopper(shopper.name, shopper.email, shopper.nif) end) end)
      |> Enum.map(&Task.await/1)
    end
  end

  describe "placing an order" do
    @tag :integration
    test "should error with unexisting merchant" do
      assert {:ok, %Shopper{} = shopper} = Shoppers.register_shopper(@valid_name, @valid_email, @valid_nif)

      assert {:error, :validation_failure,
              %{
                merchant_cif: ["invalid CIF", "unregistered merchant"]
              }} = Shoppers.place_order(shopper.id, "X1234567Y", 23)
    end

    @tag :integration
    test "should place an order when data is valid" do
      merchant_cif = "A8888888B"
      amount = 23

      assert {:ok, %Merchant{} = merchant} = Merchants.register_merchant("Acme", "acme@example.com", merchant_cif)
      assert {:ok, %Shopper{} = shopper} = Shoppers.register_shopper(@valid_name, @valid_email, @valid_nif)
      assert {:ok, %Shopper{} = shopper} = Shoppers.place_order(shopper.id, merchant_cif, amount)
    end
  end
end

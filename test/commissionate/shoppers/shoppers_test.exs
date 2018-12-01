defmodule Commissionate.ShoppersTest do
  use Commissionate.DataCase

  alias Commissionate.Shoppers
  alias Commissionate.Shoppers.Projections.Shopper

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
      assert {:error,
              [
                {:error, :name, :presence, "can't be empty"},
                {:error, :name, :format, "Invalid name"}
              ]} = Shoppers.register_shopper("", @valid_email, @valid_nif)

      assert {:error,
              [
                {:error, :email, :presence, "can't be empty"},
                {:error, :email, :email, "invalid email"}
              ]} = Shoppers.register_shopper(@valid_name, "", @valid_nif)

      assert {:error,
              [
                {:error, :nif, :presence, "can't be empty"},
                {:error, :nif, :nif, "invalid NIF"}
              ]} = Shoppers.register_shopper(@valid_name, @valid_email, "")
    end

    @tag :wip
    test "should fail when registering identical nif at same time and return error" do
      shopper = build(:shopper, nif: "INVALID")

      1..2
      |> Enum.map(fn _ -> Task.async(fn -> Shoppers.register_shopper(shopper.name, shopper.email, shopper.nif) end) end)
      |> Enum.map(&Task.await/1)
    end
  end
end

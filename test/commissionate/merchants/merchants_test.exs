defmodule Commissionate.MerchantsTest do
  use Commissionate.DataCase

  alias Commissionate.Merchants
  alias Commissionate.Merchants.Projections.Merchant

  @valid_name "Acme"
  @valid_email "acme@example.com"
  @valid_cif "A1111111B"

  describe "register merchant" do
    @tag :integration
    test "should succeed with valid data" do
      assert {:ok, %Merchant{} = merchant} = Merchants.register_merchant(@valid_name, @valid_email, @valid_cif)
      assert merchant.name == @valid_name
      assert merchant.email == @valid_email
      assert merchant.cif == @valid_cif
    end

    @tag :integration
    test "should error with invalid data" do
      assert {:error, :validation_failure, %{name: ["can't be empty", "Invalid name"]}} =
               Merchants.register_merchant("", @valid_email, @valid_cif)

      assert {:error, :validation_failure, %{email: ["can't be empty", "invalid email"]}} =
               Merchants.register_merchant(@valid_name, "", @valid_cif)

      assert {:error, :validation_failure, %{cif: ["can't be empty", "invalid CIF"]}} =
               Merchants.register_merchant(@valid_name, @valid_email, "")
    end

    @tag :wip
    test "should fail when registering identical cif at same time and return error" do
      merchant = build(:merchant, cif: "A1111111B")

      1..2
      |> Enum.map(fn _ ->
        Task.async(fn -> Merchants.register_merchant(merchant.name, merchant.email, merchant.cif) end)
      end)
      |> Enum.map(&Task.await/1)
    end
  end
end

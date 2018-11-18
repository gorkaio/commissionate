defmodule Commissionate.Merchants.Events.RegisteredTest do
  use ExUnit.Case
  use Commissionate.DataCase
  alias Commissionate.Merchants.Events.Registered
  doctest Registered

  @valid_uuid "25f5c268-d98a-42f6-9054-f6540b4fab20"
  @valid_name "John Doe"
  @valid_email "me@example.com"
  @valid_cif "A1111111B"

  describe "Registered event" do
    @tag :unit
    test "Rejects empty ids" do
      assert {:error, [{:error, :id, :uuid, "must be valid"}]} ==
               Registered.new(nil, @valid_name, @valid_email, @valid_cif)

      assert {:error, [{:error, :id, :uuid, "must be valid"}]} ==
               Registered.new("", @valid_name, @valid_email, @valid_cif)

      assert {:error, [{:error, :id, :uuid, "must be valid"}]} ==
               Registered.new("   ", @valid_name, @valid_email, @valid_cif)
    end

    @tag :unit
    test "Regects non valid UUIDs" do
      assert {:error, [{:error, :id, :uuid, "must be valid"}]} ==
               Registered.new("abcd", @valid_name, @valid_email, @valid_cif)
    end

    @tag :unit
    test "Rejects empty names" do
      assert {:error, [{:error, :name, :presence, "can't be empty"}, {:error, :name, :format, "Invalid name"}]} ==
               Registered.new(@valid_uuid, "", @valid_email, @valid_cif)

      assert {:error, [{:error, :name, :format, "Invalid name"}]} ==
               Registered.new(@valid_uuid, "   ", @valid_email, @valid_cif)

      assert {:error, [{:error, :name, :presence, "can't be empty"}, {:error, :name, :format, "Invalid name"}]} ==
               Registered.new(@valid_uuid, nil, @valid_email, @valid_cif)
    end

    @tag :unit
    test "Rejects empty email" do
      assert {:error, [{:error, :email, :presence, "can't be empty"}, {:error, :email, :email, "invalid email"}]} ==
               Registered.new(@valid_uuid, @valid_name, nil, @valid_cif)

      assert {:error, [{:error, :email, :presence, "can't be empty"}, {:error, :email, :email, "invalid email"}]} ==
               Registered.new(@valid_uuid, @valid_name, "", @valid_cif)

      assert {:error, [{:error, :email, :email, "invalid email"}]} ==
               Registered.new(@valid_uuid, @valid_name, "   ", @valid_cif)
    end

    @tag :unit
    test "Rejects invalid email addresses" do
      assert {:error, [{:error, :email, :email, "invalid email"}]} ==
               Registered.new(@valid_uuid, @valid_name, "not_an_email", @valid_cif)

      assert {:error, [{:error, :email, :email, "invalid email"}]} ==
               Registered.new(@valid_uuid, @valid_name, "also@invalid", @valid_cif)
    end

    @tag :unit
    test "Rejects empty CIFs" do
      assert {:error, [{:error, :cif, :presence, "can't be empty"}, {:error, :cif, :cif, "invalid CIF"}]} ==
               Registered.new(@valid_uuid, @valid_name, @valid_email, nil)

      assert {:error, [{:error, :cif, :presence, "can't be empty"}, {:error, :cif, :cif, "invalid CIF"}]} ==
               Registered.new(@valid_uuid, @valid_name, @valid_email, "")

      assert {:error, [{:error, :cif, :cif, "invalid CIF"}]} ==
               Registered.new(@valid_uuid, @valid_name, @valid_email, "    ")
    end

    @tag :unit
    test "Rejects invalid CIFs" do
      assert {:error, [{:error, :cif, :cif, "invalid CIF"}]} ==
               Registered.new(@valid_uuid, @valid_name, @valid_email, "000000000A")
    end

    @tag :unit
    test "Creates registered events when all data is valid" do
      assert {:ok, %Registered{id: @valid_uuid, name: @valid_name, email: @valid_email, cif: @valid_cif}} ===
               Registered.new(@valid_uuid, @valid_name, @valid_email, @valid_cif)
    end
  end
end

defmodule Commissionate.Shoppers.Commands.RegisterTest do
  use ExUnit.Case
  use Commissionate.DataCase
  alias Commissionate.Shoppers.Commands.Register
  doctest Register

  @valid_uuid "25f5c268-d98a-42f6-9054-f6540b4fab20"
  @valid_name "John Doe"
  @valid_email "me@example.com"
  @valid_nif "11111111H"

  describe "Register command" do
    @tag :unit
    test "Rejects empty ids" do
      assert {:error, [{:error, :id, :uuid, "must be valid"}]} ==
               Register.new(nil, @valid_name, @valid_email, @valid_nif)

      assert {:error, [{:error, :id, :uuid, "must be valid"}]} ==
               Register.new("", @valid_name, @valid_email, @valid_nif)

      assert {:error, [{:error, :id, :uuid, "must be valid"}]} ==
               Register.new("   ", @valid_name, @valid_email, @valid_nif)
    end

    @tag :unit
    test "Regects non valid UUIDs" do
      assert {:error, [{:error, :id, :uuid, "must be valid"}]} ==
               Register.new("abcd", @valid_name, @valid_email, @valid_nif)
    end

    @tag :unit
    test "Rejects empty names" do
      assert {:error, [{:error, :name, :presence, "can't be empty"}, {:error, :name, :format, "Invalid name"}]} ==
               Register.new(@valid_uuid, "", @valid_email, @valid_nif)

      assert {:error, [{:error, :name, :format, "Invalid name"}]} ==
               Register.new(@valid_uuid, "   ", @valid_email, @valid_nif)

      assert {:error, [{:error, :name, :presence, "can't be empty"}, {:error, :name, :format, "Invalid name"}]} ==
               Register.new(@valid_uuid, nil, @valid_email, @valid_nif)
    end

    @tag :unit
    test "Rejects empty email" do
      assert {:error, [{:error, :email, :presence, "can't be empty"}, {:error, :email, :email, "invalid email"}]} ==
               Register.new(@valid_uuid, @valid_name, nil, @valid_nif)

      assert {:error, [{:error, :email, :presence, "can't be empty"}, {:error, :email, :email, "invalid email"}]} ==
               Register.new(@valid_uuid, @valid_name, "", @valid_nif)

      assert {:error, [{:error, :email, :email, "invalid email"}]} ==
               Register.new(@valid_uuid, @valid_name, "   ", @valid_nif)
    end

    @tag :unit
    test "Rejects invalid email addresses" do
      assert {:error, [{:error, :email, :email, "invalid email"}]} ==
               Register.new(@valid_uuid, @valid_name, "not_an_email", @valid_nif)

      assert {:error, [{:error, :email, :email, "invalid email"}]} ==
               Register.new(@valid_uuid, @valid_name, "also@invalid", @valid_nif)
    end

    @tag :unit
    test "Rejects empty NIFs" do
      assert {:error, [{:error, :nif, :presence, "can't be empty"}, {:error, :nif, :nif, "invalid NIF"}]} ==
               Register.new(@valid_uuid, @valid_name, @valid_email, nil)

      assert {:error, [{:error, :nif, :presence, "can't be empty"}, {:error, :nif, :nif, "invalid NIF"}]} ==
               Register.new(@valid_uuid, @valid_name, @valid_email, "")

      assert {:error, [{:error, :nif, :nif, "invalid NIF"}]} ==
               Register.new(@valid_uuid, @valid_name, @valid_email, "    ")
    end

    @tag :unit
    test "Rejects invalid NIFs" do
      assert {:error, [{:error, :nif, :nif, "invalid NIF"}]} ==
               Register.new(@valid_uuid, @valid_name, @valid_email, "INVALID")
    end

    @tag :unit
    test "Creates register commands when all data is valid" do
      assert {:ok, %Register{id: @valid_uuid, name: @valid_name, email: @valid_email, nif: @valid_nif}} ===
               Register.new(@valid_uuid, @valid_name, @valid_email, @valid_nif)
    end
  end
end

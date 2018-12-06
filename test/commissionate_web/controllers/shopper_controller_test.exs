defmodule CommissionateWeb.ShopperControllerTest do
  use CommissionateWeb.ConnCase
  alias Commissionate.Shoppers
  import Commissionate.Factory

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "query shoppers" do
    @tag :api
    test "shows an empty list of shoppers when none is registered", %{conn: conn} do
      conn = get(conn, shopper_path(conn, :list))
      data = json_response(conn, 200)["data"]
      assert data == []
    end

    @tag :api
    test "shows a list of shoppers when some are registered", %{conn: conn} do
      {:ok, shopper1} = fixture(:shopper)
      {:ok, shopper2} = fixture(:shopper)
      conn = get(conn, shopper_path(conn, :list))
      data = json_response(conn, 200)["data"]

      assert data == [
               %{
                 "id" => shopper1.id,
                 "name" => shopper1.name,
                 "email" => shopper1.email,
                 "nif" => shopper1.nif
               },
               %{
                 "id" => shopper2.id,
                 "name" => shopper2.name,
                 "email" => shopper2.email,
                 "nif" => shopper2.nif
               }
             ]
    end

    @tag :api
    test "shows details about a shopper", %{conn: conn} do
      {:ok, shopper} = fixture(:shopper)
      conn = get(conn, shopper_path(conn, :show, shopper.nif))
      data = json_response(conn, 200)["data"]

      assert data ==
               %{
                 "id" => shopper.id,
                 "name" => shopper.name,
                 "email" => shopper.email,
                 "nif" => shopper.nif
               }
    end

    @tag :api
    test "returns an error when retrieving data of unexisting shopper", %{conn: conn} do
      conn = get(conn, shopper_path(conn, :show, "12345678X"))
      data = json_response(conn, 404)["data"]
      assert data == nil
    end
  end

  describe "query orders" do
    @tag :api
    test "shows details about an order", %{conn: conn} do
      {:ok, shopper} = fixture(:shopper)
      {:ok, merchant} = fixture(:merchant)
      amount = 23

      {:ok, order} = Shoppers.place_order(shopper.id, merchant.cif, amount)
      conn = get(conn, shopper_path(conn, :show_order, shopper.nif, order.id))

      data = json_response(conn, 200)["data"]

      assert data ==
               %{
                 "id" => order.id,
                 "amount" => amount,
                 "merchant_cif" => merchant.cif,
                 "shopper_nif" => shopper.nif,
                 "purchase_date" => DateTime.to_iso8601(order.purchase_date),
                 "confirmation_date" => nil,
                 "status" => "UNCONFIRMED"
               }
    end
  end

  describe "create shopper" do
    @tag :api
    test "renders shopper when data is valid", %{conn: conn} do
      conn =
        post(conn, shopper_path(conn, :create),
          shopper: build(:shopper, name: "Alice", email: "alice@example.com", nif: "11111111H")
        )

      json = json_response(conn, 201)["data"]

      {id, data} = Map.pop(json, "id")
      assert {:ok, _} = UUID.info(id)

      assert data == %{
               "name" => "Alice",
               "email" => "alice@example.com",
               "nif" => "11111111H"
             }
    end

    @tag :api
    test "renders errors when data is invalid", %{conn: conn} do
      shopper = build(:shopper, nif: "98098098")
      conn = post(conn, shopper_path(conn, :create), shopper: shopper)
      assert json_response(conn, 422)["errors"] != %{}
    end

    @tag :api
    test "render errors when nif has been taken", %{conn: conn} do
      {:ok, shopper} = fixture(:shopper)

      # attempt to register the same nif
      conn = post(conn, shopper_path(conn, :create), shopper: build(:shopper, nif: shopper.nif))

      assert json_response(conn, 422)["errors"] == %{
               "nif" => [
                 "already taken"
               ]
             }
    end
  end

  describe "create order" do
    @tag :api
    test "creates an order when data is valid", %{conn: conn} do
      {:ok, shopper} = fixture(:shopper)
      {:ok, merchant} = fixture(:merchant)
      amount = 23

      conn =
        post(conn, shopper_path(conn, :create_order, shopper.nif),
          order: %{"merchant_cif" => merchant.cif, "amount" => amount}
        )

      json = json_response(conn, 201)["data"]

      {id, data} = Map.pop(json, "id")
      {_purchase_date, data} = Map.pop(data, "purchase_date")
      assert {:ok, _} = UUID.info(id)

      assert data == %{
               "shopper_nif" => shopper.nif,
               "merchant_cif" => merchant.cif,
               "amount" => 23,
               "confirmation_date" => nil,
               "status" => "UNCONFIRMED"
             }
    end

    @tag :api
    test "render errors when merchant is not registered", %{conn: conn} do
      {:ok, shopper} = fixture(:shopper)

      # attempt to register with unexisting marchant
      conn =
        post(conn, shopper_path(conn, :create_order, shopper.nif),
          order: %{"merchant_cif" => "A0000000X", "amount" => 23}
        )

      assert json_response(conn, 422)["errors"] == %{
               "merchant_cif" => [
                 "unregistered merchant"
               ]
             }
    end

    @tag :api
    test "render errors when amount is invalid", %{conn: conn} do
      {:ok, shopper} = fixture(:shopper)
      {:ok, merchant} = fixture(:merchant)

      conn =
        post(conn, shopper_path(conn, :create_order, shopper.nif),
          order: %{"merchant_cif" => merchant.cif, "amount" => "ABC"}
        )

      assert json_response(conn, 422)["errors"] == %{
               "amount" => [
                 "invalid amount"
               ]
             }
    end
  end

  describe "confirm order" do
    @tag :api
    test "confirms an existing order in unconfirmed status", %{conn: conn} do
      {:ok, shopper} = fixture(:shopper)
      {:ok, merchant} = fixture(:merchant)
      {:ok, order} = Shoppers.place_order(shopper.id, merchant.cif, 23)

      conn = patch(conn, shopper_path(conn, :update_order, shopper.nif, order.id), order: %{"status" => "CONFIRMED"})

      json = json_response(conn, 200)["data"]
      {confirmation_date, data} = Map.pop(json, "confirmation_date")
      assert confirmation_date !== nil

      assert data == %{
               "id" => order.id,
               "merchant_cif" => merchant.cif,
               "shopper_nif" => shopper.nif,
               "amount" => order.amount,
               "purchase_date" => DateTime.to_iso8601(order.purchase_date),
               "status" => "CONFIRMED"
             }
    end

    @tag :api
    test "does nothing when confirming an already confirmed order", %{conn: conn} do
      {:ok, shopper} = fixture(:shopper)
      {:ok, merchant} = fixture(:merchant)
      {:ok, order} = Shoppers.place_order(shopper.id, merchant.cif, 23)
      {:ok, order} = Shoppers.confirm_order(shopper.id, order.id)

      conn = patch(conn, shopper_path(conn, :update_order, shopper.nif, order.id), order: %{"status" => "CONFIRMED"})

      assert json_response(conn, 200)["data"] == %{
               "id" => order.id,
               "merchant_cif" => merchant.cif,
               "shopper_nif" => shopper.nif,
               "amount" => order.amount,
               "purchase_date" => DateTime.to_iso8601(order.purchase_date),
               "confirmation_date" => DateTime.to_iso8601(order.confirmation_date),
               "status" => "CONFIRMED"
             }
    end
  end
end

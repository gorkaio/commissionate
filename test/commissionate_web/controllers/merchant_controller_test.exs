defmodule CommissionateWeb.MerchantControllerTest do
  use CommissionateWeb.ConnCase

  import Commissionate.Factory

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "query merchants" do
    @tag :api
    test "shows an empty list of merchants when none is registered", %{conn: conn} do
      conn = get(conn, merchant_path(conn, :list))
      data = json_response(conn, 200)["data"]
      assert data == []
    end

    @tag :api
    test "shows a list of merchants when some are registered", %{conn: conn} do
      {:ok, merchant1} = fixture(:merchant)
      {:ok, merchant2} = fixture(:merchant)
      conn = get(conn, merchant_path(conn, :list))
      data = json_response(conn, 200)["data"]

      assert data == [
               %{
                 "id" => merchant1.id,
                 "name" => merchant1.name,
                 "email" => merchant1.email,
                 "cif" => merchant1.cif
               },
               %{
                 "id" => merchant2.id,
                 "name" => merchant2.name,
                 "email" => merchant2.email,
                 "cif" => merchant2.cif
               }
             ]
    end

    @tag :api
    test "returns an error when retrieving data of unexisting merchant", %{conn: conn} do
      conn = get(conn, merchant_path(conn, :show, "A1234578X"))
      data = json_response(conn, 404)["data"]
      assert data == nil
    end

    @tag :api
    test "shows details about a merchant", %{conn: conn} do
      {:ok, merchant} = fixture(:merchant)
      conn = get(conn, merchant_path(conn, :show, merchant.cif))
      data = json_response(conn, 200)["data"]

      assert data ==
               %{
                 "id" => merchant.id,
                 "name" => merchant.name,
                 "email" => merchant.email,
                 "cif" => merchant.cif
               }
    end
  end

  describe "create merchant" do
    @tag :api
    test "renders merchant when data is valid", %{conn: conn} do
      conn =
        post(conn, merchant_path(conn, :create),
          merchant: build(:merchant, name: "Acme", email: "acme@example.com", cif: "A1111111B")
        )

      json = json_response(conn, 201)["data"]

      {id, data} = Map.pop(json, "id")
      assert {:ok, _} = UUID.info(id)

      assert data == %{
               "name" => "Acme",
               "email" => "acme@example.com",
               "cif" => "A1111111B"
             }
    end

    @tag :api
    test "renders errors when data is invalid", %{conn: conn} do
      merchant = build(:merchant, cif: "INVALID")
      conn = post(conn, merchant_path(conn, :create), merchant: merchant)
      assert json_response(conn, 422)["errors"] != %{}
    end

    @tag :api
    test "render errors when cif has been taken", %{conn: conn} do
      {:ok, merchant} = fixture(:merchant)

      # attempt to register the same cif
      conn = post(conn, merchant_path(conn, :create), merchant: build(:merchant, cif: merchant.cif))

      assert json_response(conn, 422)["errors"] == %{
               "cif" => [
                 "already taken"
               ]
             }
    end
  end
end

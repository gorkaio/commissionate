defmodule CommissionateWeb.MerchantControllerTest do
  use CommissionateWeb.ConnCase

  import Commissionate.Factory

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create merchant" do
    @tag :api
    test "renders merchant when data is valid", %{conn: conn} do
      conn =
        post(conn, merchant_path(conn, :create),
          merchant: build(:merchant, name: "Acme", email: "acme@example.com", cif: "A1111111B")
        )

      json = json_response(conn, 201)["merchant"]

      {id, data} = Map.pop(json, :id)
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
                 "cif already taken"
               ]
             }
    end
  end
end

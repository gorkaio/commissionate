defmodule CommissionateWeb.ShopperControllerTest do
  use CommissionateWeb.ConnCase

  import Commissionate.Factory

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create shopper" do
    @tag :api
    test "renders shopper when data is valid", %{conn: conn} do
      conn =
        post(conn, shopper_path(conn, :create),
          shopper: build(:shopper, name: "Alice", email: "alice@example.com", nif: "11111111H")
        )

      json = json_response(conn, 201)["shopper"]

      {id, data} = Map.pop(json, :id)
      assert {:ok, _} = UUID.info(id)

      assert data == %{
               "name" => "Alice",
               "email" => "alice@example.com",
               "cif" => "11111111H"
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
                 "nif already taken"
               ]
             }
    end
  end
end

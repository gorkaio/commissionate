defmodule CommissionateWeb.MerchantController do
  use CommissionateWeb, :controller

  alias Commissionate.Merchants
  alias Commissionate.Merchants.Projections.Merchant

  action_fallback(CommissionateWeb.FallbackController)

  def list(conn, _params) do
    merchants = Merchants.list_merchants()
    render(conn, "index.json", merchants: merchants)
  end

  def create(conn, %{"merchant" => %{"name" => name, "email" => email, "cif" => cif}}) do
    with {:ok, %Merchant{} = merchant} <- Merchants.register_merchant(name, email, cif) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", merchant_path(conn, :show, cif))
      |> render("show.json", merchant: merchant)
    end
  end

  def show(conn, %{"cif" => cif}) do
    merchant = Merchants.merchant_by_cif(cif)
    render(conn, "show.json", merchant: merchant)
  end
end

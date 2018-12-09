defmodule CommissionateWeb.DisbursementController do
  use CommissionateWeb, :controller

  alias Commissionate.Merchants

  action_fallback(CommissionateWeb.FallbackController)

  def list(conn, params) do
    disbursements = Merchants.list_disbursements(params)
    render(conn, CommissionateWeb.DisbursementView, "index.json", disbursements: disbursements)
  end
end

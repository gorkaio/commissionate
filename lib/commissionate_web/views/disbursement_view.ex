defmodule CommissionateWeb.DisbursementView do
  use CommissionateWeb, :view
  alias CommissionateWeb.DisbursementView

  def render("index.json", %{disbursements: disbursements}) do
    %{data: render_many(disbursements, DisbursementView, "disbursement.json")}
  end

  def render("show.json", %{disbursement: disbursement}) do
    %{data: render_one(disbursement, DisbursementView, "order.json")}
  end

  def render("disbursement.json", %{disbursement: disbursement}) do
    %{
      payment_date: disbursement.payment_date,
      amount: disbursement.amount,
      merchant_cif: disbursement.merchant_cif
    }
  end
end

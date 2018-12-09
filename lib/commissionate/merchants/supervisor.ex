defmodule Commissionate.Merchants.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_arg) do
    Supervisor.init(
      [
        Commissionate.Merchants.Projectors.Merchant,
        Commissionate.Merchants.Projectors.Disbursement,
        Commissionate.Merchants.Workflows.OrderConfirmation
      ],
      strategy: :one_for_one
    )
  end
end

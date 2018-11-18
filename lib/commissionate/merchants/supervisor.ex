defmodule Commissionate.Merchants.Supervisor do
  use Supervisor

  alias Commissionate.Merchants

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_arg) do
    Supervisor.init(
      [
        Merchants.Projectors.Merchant
      ],
      strategy: :one_for_one
    )
  end
end

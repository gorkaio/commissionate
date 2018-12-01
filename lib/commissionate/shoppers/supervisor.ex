defmodule Commissionate.Shoppers.Supervisor do
  use Supervisor

  alias Commissionate.Shoppers

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_arg) do
    Supervisor.init(
      [
        Shoppers.Projectors.Shopper
      ],
      strategy: :one_for_one
    )
  end
end

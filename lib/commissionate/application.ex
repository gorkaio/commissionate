defmodule Commissionate.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(Commissionate.Repo, []),
      supervisor(CommissionateWeb.Endpoint, []),
      supervisor(Commissionate.Merchants.Supervisor, []),
      worker(Commissionate.Support.Unique, [])
    ]

    opts = [strategy: :one_for_one, name: Commissionate.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    CommissionateWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

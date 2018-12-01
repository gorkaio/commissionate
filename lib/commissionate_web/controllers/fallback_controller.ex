defmodule CommissionateWeb.FallbackController do
  use CommissionateWeb, :controller

  def call(conn, {:error, :validation_failure, errors}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(CommissionateWeb.ValidationView, "error.json", errors: errors)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(CommissionateWeb.ErrorView, :"404")
  end
end

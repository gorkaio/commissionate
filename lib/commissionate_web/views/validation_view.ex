defmodule CommissionateWeb.ValidationView do
  use CommissionateWeb, :view

  def render("error.json", %{errors: errors}) do
    %{errors: errors}
  end
end

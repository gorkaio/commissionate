defmodule Commissionate.DataCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Commissionate.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Commissionate.Factory
      import Commissionate.Fixture
      import Commissionate.Storage
    end
  end

  setup do
    Commissionate.Storage.reset!()

    :ok
  end
end

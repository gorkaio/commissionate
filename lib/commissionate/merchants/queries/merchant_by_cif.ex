defmodule Commissionate.Merchants.Queries.MerchantByCif do
  import Ecto.Query

  alias Commissionate.Merchants.Projections.Merchant

  def new(cif) do
    from(m in Merchant,
      where: m.cif == ^cif
    )
  end
end

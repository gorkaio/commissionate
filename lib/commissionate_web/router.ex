defmodule CommissionateWeb.Router do
  use CommissionateWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", CommissionateWeb do
    pipe_through(:api)
    post("/merchants", MerchantController, :create)
    get("/merchants", MerchantController, :list)
    get("/merchants/:cif", MerchantController, :show)

    post("/shoppers", ShopperController, :create)
    get("/shoppers", ShopperController, :list)
    get("/shoppers/:nif", ShopperController, :show)
  end
end

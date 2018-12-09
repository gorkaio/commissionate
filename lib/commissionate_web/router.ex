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

    get("/disbursements", DisbursementController, :list)

    post("/shoppers", ShopperController, :create)
    get("/shoppers", ShopperController, :list)
    get("/shoppers/:nif", ShopperController, :show)
    post("/shoppers/:nif/orders", ShopperController, :create_order)
    get("/shoppers/:nif/orders", ShopperController, :list_orders)
    get("/shoppers/:nif/orders/:order_id", ShopperController, :show_order)
    patch("/shoppers/:nif/orders/:order_id", ShopperController, :update_order)

    get("/orders", OrdersController, :list)
  end
end

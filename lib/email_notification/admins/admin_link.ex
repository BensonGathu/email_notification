defmodule EmailNotification.Admins.AdminLink do
  use Ecto.Schema
  import Ecto.Changeset

  schema "admin_links" do

    belongs_to :admin, MyApp.User, foreign_key: :admin_id
    belongs_to :user, MyApp.User, foreign_key: :user_id


    timestamps()
  end

  @doc false
  def changeset(admin_link, attrs) do
    admin_link
    |> cast(attrs, [:admin_id, :user_id])
    |> validate_required([])
  end
end

defmodule EmailNotification.Admins.Admin do
  use Ecto.Schema
  import Ecto.Changeset

  schema "admins" do
    field :admin_role, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(admin, attrs) do
    admin
    |> cast(attrs, [:admin_role])
    |> validate_required([:admin_role])
  end
end

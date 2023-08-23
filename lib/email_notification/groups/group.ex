defmodule EmailNotification.Groups.Group do
  use Ecto.Schema
  import Ecto.Changeset

  schema "groups" do
    field :name, :string
    belongs_to :user, EmailNotification.Accounts.User


    timestamps()
  end

  @doc false
  def changeset(group, attrs) do
    group
    |> cast(attrs, [:name, :user_id])
    |> validate_required([:name, :user_id])
  end
end

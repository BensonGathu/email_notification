defmodule EmailNotification.Roles.Role do
  use Ecto.Schema
  import Ecto.Changeset

  schema "roles" do
    field :name, :string
    field :permissions, {:array, :string}

    has_many :users, EmailNotification.Accounts.User


    timestamps() 
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name, :permissions])
    |> validate_required([:name])
  end
end

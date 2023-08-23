defmodule EmailNotification.UsersTest do
  use EmailNotification.DataCase

  alias EmailNotification.Users

  describe "users" do
    alias EmailNotification.Users.User

    import EmailNotification.UsersFixtures

    @invalid_attrs %{plan: nil, role: nil, first_name: nil, last_name: nil, email_address: nil, msisdn: nil, password_hash: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Users.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Users.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{plan: "some plan", role: "some role", first_name: "some first_name", last_name: "some last_name", email_address: "some email_address", msisdn: "some msisdn", password_hash: "some password_hash"}

      assert {:ok, %User{} = user} = Users.create_user(valid_attrs)
      assert user.plan == "some plan"
      assert user.role == "some role"
      assert user.first_name == "some first_name"
      assert user.last_name == "some last_name"
      assert user.email_address == "some email_address"
      assert user.msisdn == "some msisdn"
      assert user.password_hash == "some password_hash"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{plan: "some updated plan", role: "some updated role", first_name: "some updated first_name", last_name: "some updated last_name", email_address: "some updated email_address", msisdn: "some updated msisdn", password_hash: "some updated password_hash"}

      assert {:ok, %User{} = user} = Users.update_user(user, update_attrs)
      assert user.plan == "some updated plan"
      assert user.role == "some updated role"
      assert user.first_name == "some updated first_name"
      assert user.last_name == "some updated last_name"
      assert user.email_address == "some updated email_address"
      assert user.msisdn == "some updated msisdn"
      assert user.password_hash == "some updated password_hash"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_user(user, @invalid_attrs)
      assert user == Users.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Users.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Users.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Users.change_user(user)
    end
  end
end

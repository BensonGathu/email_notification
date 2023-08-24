defmodule EmailNotification.GroupContactsTest do
  use EmailNotification.DataCase

  alias EmailNotification.GroupContacts

  describe "groupcontacts" do
    alias EmailNotification.GroupContacts.GroupContact

    import EmailNotification.GroupContactsFixtures

    @invalid_attrs %{}

    test "list_groupcontacts/0 returns all groupcontacts" do
      group_contact = group_contact_fixture()
      assert GroupContacts.list_groupcontacts() == [group_contact]
    end

    test "get_group_contact!/1 returns the group_contact with given id" do
      group_contact = group_contact_fixture()
      assert GroupContacts.get_group_contact!(group_contact.id) == group_contact
    end

    test "create_group_contact/1 with valid data creates a group_contact" do
      valid_attrs = %{}

      assert {:ok, %GroupContact{} = group_contact} = GroupContacts.create_group_contact(valid_attrs)
    end

    test "create_group_contact/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = GroupContacts.create_group_contact(@invalid_attrs)
    end

    test "update_group_contact/2 with valid data updates the group_contact" do
      group_contact = group_contact_fixture()
      update_attrs = %{}

      assert {:ok, %GroupContact{} = group_contact} = GroupContacts.update_group_contact(group_contact, update_attrs)
    end

    test "update_group_contact/2 with invalid data returns error changeset" do
      group_contact = group_contact_fixture()
      assert {:error, %Ecto.Changeset{}} = GroupContacts.update_group_contact(group_contact, @invalid_attrs)
      assert group_contact == GroupContacts.get_group_contact!(group_contact.id)
    end

    test "delete_group_contact/1 deletes the group_contact" do
      group_contact = group_contact_fixture()
      assert {:ok, %GroupContact{}} = GroupContacts.delete_group_contact(group_contact)
      assert_raise Ecto.NoResultsError, fn -> GroupContacts.get_group_contact!(group_contact.id) end
    end

    test "change_group_contact/1 returns a group_contact changeset" do
      group_contact = group_contact_fixture()
      assert %Ecto.Changeset{} = GroupContacts.change_group_contact(group_contact)
    end
  end
end

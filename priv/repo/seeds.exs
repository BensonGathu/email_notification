# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     EmailNotification.Repo.insert!(%EmailNotification.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.


# role_admin = MyApp.Role.insert(%{name: "admin"})
# role_user = MyApp.Role.insert(%{name: "user"})
# EmailNotification.Roles.Role.insert(%{name: "admin", permissions: ["superuser"] })
# EmailNotification.Roles.Role.insert(%{name: "user"})
# admin_user = MyApp.User.insert(%{name: "Admin User", role_id: role_admin.id})
# user1 = MyApp.User.insert(%{name: "Regular User 1", role_id: role_user.id})
# user2 = MyApp.User.insert(%{name: "Regular User 2", role_id: role_user.id})

# # Create admin-user relationships
# MyApp.AdminLink.insert(%{admin_id: admin_user.id, user_id: user1.id})
# MyApp.AdminLink.insert(%{admin_id: admin_user.id, user_id: user2.id})

# new_role_params = %{name: "admin", permissions: ["superuser"] }
# new_role = %EmailNotification.Roles.Role{} |> EmailNotification.Roles.Role.changeset(new_role_params) |> EmailNotification.Repo.insert!()

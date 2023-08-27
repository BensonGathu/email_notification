defmodule EmailNotification.Roles do

import Ecto.Query, warn: false
alias EmailNotification.Repo
alias EmailNotification.Roles.Role


alias EmailNotification.Groups.Group

def list_roles do
  Repo.all(Role)
end


end

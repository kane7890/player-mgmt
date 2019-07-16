require './config/environment'

if ActiveRecord::Migrator.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
end

use Rack::MethodOverride
# PlayersController and UsersController are used, in addition to running ApplicationController
use PlayersController
use UsersController
run ApplicationController

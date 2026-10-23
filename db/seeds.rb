# Roles
roles = {
  "Admin"    => "System administrator — user management, reports, menu editing. No transaction operations.",
  "Manager"  => "Operations manager — can void transactions, authorize discounts, manage shifts.",
  "Cashier"  => "Cashier — take orders, charge payments, apply promos.",
  "Kitchen"  => "Kitchen staff — update order status on KDS.",
  "Customer" => "Registered customer — order via web, view history."
}.map do |name, description|
  Role.find_or_create_by!(name: name) { |r| r.description = description }
end.to_h { |r| [ r.name, r ] }

# Permissions
permission_defs = [
  %w[menu view],          %w[menu edit],
  %w[orders update_status],
  %w[payments charge],    %w[payments void_refund],
  %w[promos apply],       %w[promos create],
  %w[users manage],
  %w[reports view],
  %w[inventory view],     %w[inventory adjust],
  %w[shifts manage],      %w[shifts clock]
]

permissions = permission_defs.map do |mod, action|
  Permission.find_or_create_by!(module: mod, action: action)
end.to_h { |p|[ p.key, p ] }

# Role → permission matrix
matrix = {
  "Admin"    => %w[menu/view menu/edit promos/create users/manage reports/view inventory/view inventory/adjust shifts/manage],
  "Manager"  => %w[menu/view menu/edit orders/update_status payments/charge payments/void_refund promos/apply promos/create reports/view inventory/view inventory/adjust shifts/manage shifts/clock],
  "Cashier"  => %w[menu/view orders/update_status payments/charge promos/apply inventory/view shifts/clock],
  "Kitchen"  => %w[menu/view orders/update_status inventory/view shifts/clock],
  "Customer" => %w[menu/view payments/charge promos/apply]
}

matrix.each do |role_name, keys|
  role = roles.fetch(role_name)
  keys.each do |key|
    RolePermission.find_or_create_by!(role: role, permission: permissions.fetch(key))
  end
end

# # Admin user
admin = User.find_or_initialize_by(username: "admin")
role = Role.find_by(name: "Admin")
admin.assign_attributes(
  name: "System Admin",
  role: role,
  status: :active,
  confirmed_at: Time.current
)
admin.password = "ChangeMe123!"
admin.save!

# Demo manager (has PIN)
manager = User.find_or_initialize_by(username: "manager")
role2= Role.find_by(name: "Manager")
manager.assign_attributes(
  name: "Restaurant Manager",
  role: role2,
  status: :active,
  confirmed_at: Time.current
)
manager.password = "ChangeMe123!"
manager.set_pin("1234")
manager.save!

puts "Seeded roles: #{Role.pluck(:name).join(', ')}"
puts "Seeded permissions: #{Permission.count}"
puts "Admin login: admin / ChangeMe123!"
puts "Manager login: manager / ChangeMe123! (PIN: 1234)"

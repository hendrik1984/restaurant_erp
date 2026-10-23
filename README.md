# README

M1: User Management (1 week)
Objective: Complete authentication, authorization, and PIN approval for sensitive operations.

Tasks
  - Use Rails 8.1 built-in bin/rails generate authentication to generate base authentication (Rails 8 new feature, includes Session and password reset)
  - Extend User model: add role_id, status, phone
  - Create Role, Permission, RolePermission models and migrations
  - Implement permission matrix: Module × Action (view/edit/void/manage)
  - Seed default roles: Admin, Manager, Cashier, Kitchen
  - Implement Manager PIN interception for sensitive operations (void/refund/discount)
  - Implement staff clock in/out (PIN + timestamp)
  - Tailwind styling: login page, user list, user form, role permission editing page
  - Add Pundit or CanCanCan (choose one) for permission enforcement
  - Write request specs: login, permission denial, PIN interception

Acceptance Criteria
  - Admin can CRUD users, assign roles
  - Cashier sees only permitted menu items
  - Void operations without Manager PIN are blocked
  - PIN clock in/out records timestamps

M2: Menu & Banner Management (1 week)
Objective: Achieve full CRUD for menu items and promotional banners.

Tasks
  - Models: Category, MenuItem, Modifier, ModifierOption, Banner
  - Menu item fields: name, description, price, category, image, available, tax_category
  - Implement CRUD controllers and Tailwind views
  - Banner: image, link_target (menu item/promo page), start/end time, active toggle
  - Menu item availability toggle (sold out/available)
  - Add Active Storage for image uploads (local disk or S3-compatible)
  - Write model specs and request specs

Acceptance Criteria
  - Admin can add "Nasi Goreng" under "Main Course" with price and image
  - Sold out items automatically hidden from Cashier order page
  - Banner can be set to display only during specific time periods

M3: KDS Real-time Kitchen Display (1.5 weeks)
Objective: After order confirmation, kitchen screen displays new orders in real-time (<2 seconds), status flow is traceable.

Tasks
  - Models: Order, OrderItem, OrderItemModifier
  - Order status state machine: pending → preparing → ready → served
  - Configure Action Cable (Redis adapter) + Turbo Streams to push to kitchen channel
  - KDS frontend page: 3-column kanban (Pending / Preparing / Ready), each order card shows items, modifiers, table number (if any), time
  - Cashier order creation page: select menu item → add modifiers → confirm
  - Kitchen click status update → automatically broadcast to other clients
  - Add Rails 8.1 Rails.event.notify to record order status change events (structured logging)
  - If RabbitMQ is genuinely needed: use for order queue decoupling, but recommend postponing decision to M3 completion and first measure with Redis solution
  - Write system specs: order creation → KDS receives → status update → Cashier sees completion

Acceptance Criteria
  - New order appears in KDS within 2 seconds
  - Kitchen marks "Ready", Cashier/POS terminal receives notification simultaneously
  - Order status changes have audit logs

M4: Payment & Promotions (1.5 weeks)
Objective: Complete order settlement, multiple payment methods, discount calculation.

Tasks
  - Models: Payment, Promo, PromoApplication
  - Payment methods: cash, debit/credit card, QRIS (Indonesian market), record payment method and amount
  - Split bill: one order supports multiple payment records
  - Void/refund process (requires Manager PIN from M1)
  - Promo types: percentage, fixed amount, item-level, time-based
  - Promo application logic: automatic or code entry, verify validity period and usage limits
  - Receipt generation (PDF or HTML print view), includes tax calculation
  - Connect payment completion event → trigger inventory deduction (M5 will implement, first reserve interface)
  - Write feature specs: cash payment, card payment, promo application, void interception

Acceptance Criteria
  - Cashier completes order + payment in ≤3 interaction steps
  - Promo correctly calculates discount, does not stack (unless rule allows)
  - Void operation requires Manager PIN
  - Receipt shows tax and total

M5: Inventory & Recipe Costing (2 weeks)
Objective: Link menu items to ingredients, real-time cost calculation, automatic stock deduction.

Tasks
  - Models: Ingredient, Recipe, RecipeItem (BOM), StockMovement
  - Recipe BOM: menu item → ingredient + quantity + unit
  - Stock deduction logic: on order payment completion, calculate required ingredient quantities based on BOM, deduct inventory, generate StockMovement record
  - Low stock alerts: threshold configuration, dashboard warnings
  - Cost calculation: ingredient unit price × BOM quantity = dish cost; combined with selling price to calculate margin
  - Ingredient price update interface: manually update purchase price, trigger all related dish cost recalculation
  - Dashboard: today's food cost rate, low stock ingredient list
  - Write service specs: BOM deduction accuracy, cost calculation accuracy

Acceptance Criteria
  - Selling 1 "Beef Burger" automatically deducts 1 bun, 1 patty, 0.05kg cheese
  - After ingredient price increase, dish margin automatically updates
  - Low stock alerts visible on dashboard

M6: Financial Reports & CRM (1.5 weeks)
Objective: Daily sales reports, tax summary, customer profiles and loyalty points.

Tasks
  - Report page: daily sales amount, order count, average order value, tax summary
  - Date range filtering, CSV export
  - Simple P&L: sales - food cost - discounts = gross profit
  - Models: Customer, LoyaltyPoint, PointTransaction
  - Customer phone/email as identifier, accumulate order history
  - Loyalty points: fixed points per amount spent, redemption rules
  - Targeted promo: apply based on customer order history (phase 1 can manually select customers)
  - Write report service specs

Acceptance Criteria
  - Owner can view today's revenue and tax in one page
  - Customer repeat purchase shows historical orders
  - Loyalty points correctly accumulate and redeem

M7: Procurement & Workforce (Phase 2, 2 weeks)
Objective: Supplier management, purchase orders, shift scheduling.

Tasks
  - Models: Supplier, PurchaseOrder, PurchaseOrderItem, Shift
  - Purchase order: create → send to supplier → receive goods → automatically update ingredient stock and price
  - Supplier records and price history
  - Shift scheduling: weekly view, assign staff, conflict detection
  - Hours statistics: clock in/out data aggregated by week, overtime marking
  - Basic payroll export (CSV)

Acceptance Criteria
  - Goods receiving automatically increases inventory
  - Weekly schedule visible, staff can see their shifts
  - Hours summary exportable

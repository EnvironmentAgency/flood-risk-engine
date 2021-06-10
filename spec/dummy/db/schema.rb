# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2016_07_15_144402) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "enrollment_exports", id: :serial, force: :cascade do |t|
    t.date "from_date", null: false
    t.date "to_date", null: false
    t.string "created_by", null: false
    t.string "file_name", null: false
    t.integer "state", default: 0, null: false
    t.text "failure_text"
    t.integer "record_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "date_field_scope", default: 0
    t.index ["created_at"], name: "index_enrollment_exports_on_created_at"
    t.index ["file_name"], name: "index_enrollment_exports_on_file_name", unique: true
  end

  create_table "flood_risk_engine_address_searches", id: :serial, force: :cascade do |t|
    t.integer "enrollment_id", null: false
    t.string "postcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["enrollment_id"], name: "index_flood_risk_engine_address_searches_on_enrollment_id"
  end

  create_table "flood_risk_engine_addresses", id: :serial, force: :cascade do |t|
    t.string "premises", limit: 200
    t.string "street_address", limit: 160
    t.string "locality", limit: 70
    t.string "city", limit: 30
    t.string "postcode", limit: 8
    t.integer "county_province_id"
    t.string "country_iso", limit: 3
    t.integer "address_type", default: 0, null: false
    t.string "organisation", limit: 255, default: "", null: false
    t.date "state_date"
    t.string "blpu_state_code"
    t.string "postal_address_code"
    t.string "logical_status_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "addressable_id"
    t.string "addressable_type"
    t.string "uprn"
    t.string "token"
    t.index ["addressable_id", "addressable_type"], name: "by_addressable"
    t.index ["token"], name: "index_flood_risk_engine_addresses_on_token", unique: true
    t.index ["uprn"], name: "index_flood_risk_engine_addresses_on_uprn"
  end

  create_table "flood_risk_engine_comments", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "commentable_id"
    t.string "commentable_type"
    t.text "content"
    t.string "event"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commentable_type", "commentable_id"], name: "commentable_idx"
  end

  create_table "flood_risk_engine_contacts", id: :serial, force: :cascade do |t|
    t.integer "contact_type", default: 0, null: false
    t.integer "title", default: 0, null: false
    t.string "suffix"
    t.date "date_of_birth"
    t.string "position", limit: 255
    t.string "email_address"
    t.string "telephone_number"
    t.integer "partnership_organisation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "full_name", limit: 255, default: "", null: false
    t.index ["email_address"], name: "index_flood_risk_engine_contacts_on_email_address"
    t.index ["full_name"], name: "index_flood_risk_engine_contacts_on_full_name"
    t.index ["partnership_organisation_id"], name: "fre_contacts_partnership_organisation_id"
  end

  create_table "flood_risk_engine_enrollments", id: :serial, force: :cascade do |t|
    t.integer "applicant_contact_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "organisation_id"
    t.string "step", limit: 50
    t.integer "correspondence_contact_id"
    t.string "token"
    t.integer "secondary_contact_id"
    t.datetime "submitted_at"
    t.integer "reference_number_id"
    t.integer "updated_by_user_id"
    t.index ["applicant_contact_id"], name: "index_flood_risk_engine_enrollments_on_applicant_contact_id"
    t.index ["correspondence_contact_id"], name: "fre_enrollments_correspondence_contact_id"
    t.index ["organisation_id"], name: "index_flood_risk_engine_enrollments_on_organisation_id"
    t.index ["reference_number_id"], name: "index_flood_risk_engine_enrollments_on_reference_number_id", unique: true
    t.index ["secondary_contact_id"], name: "index_flood_risk_engine_enrollments_on_secondary_contact_id"
    t.index ["token"], name: "index_flood_risk_engine_enrollments_on_token", unique: true
    t.index ["updated_by_user_id"], name: "index_flood_risk_engine_enrollments_on_updated_by_user_id"
  end

  create_table "flood_risk_engine_enrollments_exemptions", id: :serial, force: :cascade do |t|
    t.integer "enrollment_id", null: false
    t.integer "exemption_id", null: false
    t.integer "status", default: 0
    t.datetime "expires_at"
    t.datetime "valid_from"
    t.boolean "asset_found", default: false
    t.boolean "salmonid_river_found", default: false
    t.integer "deregister_reason"
    t.integer "assistance_mode", default: 0
    t.index ["deregister_reason"], name: "by_deregister_reason"
    t.index ["enrollment_id", "exemption_id"], name: "fre_enrollments_exemptions_enrollment_id_exemption_id", unique: true
  end

  create_table "flood_risk_engine_exemptions", id: :serial, force: :cascade do |t|
    t.string "code"
    t.string "summary"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "code_number"
    t.index ["code_number"], name: "index_flood_risk_engine_exemptions_on_code_number"
  end

  create_table "flood_risk_engine_locations", id: :serial, force: :cascade do |t|
    t.string "easting"
    t.string "northing"
    t.string "grid_reference"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "locatable_id"
    t.string "locatable_type"
    t.text "description"
    t.string "dredging_length"
    t.integer "water_management_area_id"
    t.index ["locatable_id", "locatable_type"], name: "by_locatable"
  end

  create_table "flood_risk_engine_organisations", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "contact_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "org_type"
    t.string "registration_number", limit: 12
    t.text "searchable_content"
    t.index ["contact_id"], name: "index_flood_risk_engine_organisations_on_contact_id"
    t.index ["org_type"], name: "index_flood_risk_engine_organisations_on_org_type"
    t.index ["registration_number"], name: "index_flood_risk_engine_organisations_on_registration_number"
    t.index ["searchable_content"], name: "index_flood_risk_engine_organisations_on_searchable_content"
  end

  create_table "flood_risk_engine_partners", id: :serial, force: :cascade do |t|
    t.integer "organisation_id"
    t.integer "contact_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_flood_risk_engine_partners_on_contact_id"
    t.index ["organisation_id"], name: "index_flood_risk_engine_partners_on_organisation_id"
  end

  create_table "flood_risk_engine_reference_numbers", id: :serial, force: :cascade do |t|
    t.string "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["number"], name: "index_flood_risk_engine_reference_numbers_on_number"
  end

  create_table "flood_risk_engine_water_management_areas", id: :serial, force: :cascade do |t|
    t.string "code", null: false
    t.string "long_name", null: false
    t.string "short_name"
    t.integer "area_id"
    t.string "area_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "fre_water_boundary_areas_code", unique: true
  end

  create_table "not_in_engines", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "resource_id"
    t.string "resource_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
  end

  create_table "sessions", id: :serial, force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.integer "invited_by_id"
    t.string "invited_by_type"
    t.integer "invitations_count", default: 0
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.text "disabled_comment"
    t.datetime "disabled_at"
    t.datetime "locked_at"
    t.string "role_names"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "unique_session_id", limit: 20
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id", "invited_by_type"], name: "index_users_on_invited_by_id_and_invited_by_type"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
  end

  create_table "version_associations", id: :serial, force: :cascade do |t|
    t.integer "version_id"
    t.string "foreign_key_name", null: false
    t.integer "foreign_key_id"
    t.index ["foreign_key_name", "foreign_key_id"], name: "index_version_associations_on_foreign_key"
    t.index ["version_id"], name: "index_version_associations_on_version_id"
  end

  create_table "versions", id: :serial, force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.string "status"
    t.string "whodunnit_email"
    t.string "ip"
    t.string "user_agent"
    t.integer "transaction_id"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
    t.index ["transaction_id"], name: "index_versions_on_transaction_id"
  end

  add_foreign_key "flood_risk_engine_address_searches", "flood_risk_engine_enrollments", column: "enrollment_id"
  add_foreign_key "flood_risk_engine_contacts", "flood_risk_engine_organisations", column: "partnership_organisation_id"
  add_foreign_key "flood_risk_engine_enrollments", "flood_risk_engine_contacts", column: "applicant_contact_id"
  add_foreign_key "flood_risk_engine_enrollments", "flood_risk_engine_contacts", column: "secondary_contact_id"
  add_foreign_key "flood_risk_engine_enrollments", "flood_risk_engine_organisations", column: "organisation_id"
  add_foreign_key "flood_risk_engine_enrollments_exemptions", "flood_risk_engine_enrollments", column: "enrollment_id"
  add_foreign_key "flood_risk_engine_enrollments_exemptions", "flood_risk_engine_exemptions", column: "exemption_id"
  add_foreign_key "flood_risk_engine_organisations", "flood_risk_engine_contacts", column: "contact_id"
  add_foreign_key "flood_risk_engine_partners", "flood_risk_engine_contacts", column: "contact_id"
  add_foreign_key "flood_risk_engine_partners", "flood_risk_engine_organisations", column: "organisation_id"
  add_foreign_key "users_roles", "roles"
  add_foreign_key "users_roles", "users"
end

#!/usr/bin/env ruby
# frozen_string_literal: true

# Validates providers.yml for CI
# Checks: valid YAML, required fields, no duplicate keynames, URL format, valid categories

require "yaml"

PROVIDERS_PATH = File.expand_path("../../providers.yml", __dir__)

REQUIRED_FIELDS = %w[keyname display_name category authorize_url token_url pkce_enabled].freeze

VALID_CATEGORIES = %w[
  ai analytics communication content crm design dev-tools e-commerce
  education entertainment file-storage finance fitness gaming healthcare
  hr identity logistics marketing other productivity security smart-home
  social support travel
].freeze

errors = []

# Parse YAML
begin
  providers = YAML.load_file(PROVIDERS_PATH)
rescue Psych::SyntaxError => e
  puts "FAIL: Invalid YAML syntax"
  puts e.message
  exit 1
end

unless providers.is_a?(Array)
  puts "FAIL: providers.yml must be a YAML array"
  exit 1
end

puts "Loaded #{providers.size} providers"

# Check each provider
keynames = []

providers.each_with_index do |provider, index|
  label = provider["keyname"] || "entry ##{index + 1}"

  # Required fields
  REQUIRED_FIELDS.each do |field|
    if provider[field].nil? || provider[field].to_s.strip.empty?
      errors << "#{label}: missing required field '#{field}'"
    end
  end

  # Duplicate keynames
  keyname = provider["keyname"].to_s
  if keynames.include?(keyname)
    errors << "#{label}: duplicate keyname"
  end
  keynames << keyname

  # URL format
  %w[authorize_url token_url].each do |url_field|
    url = provider[url_field].to_s
    next if url.empty?

    unless url.start_with?("https://") || url.include?("${connectionConfig")
      errors << "#{label}: #{url_field} must start with https:// or contain ${connectionConfig"
    end
  end

  # Category validation
  category = provider["category"].to_s
  unless category.empty? || VALID_CATEGORIES.include?(category)
    errors << "#{label}: invalid category '#{category}' (valid: #{VALID_CATEGORIES.join(", ")})"
  end

  # pkce_enabled format
  pkce = provider["pkce_enabled"].to_s
  unless %w[yes no].include?(pkce)
    errors << "#{label}: pkce_enabled must be 'yes' or 'no', got '#{pkce}'"
  end
end

if errors.any?
  puts "\nFAIL: #{errors.size} validation error(s)\n\n"
  errors.each { |e| puts "  - #{e}" }
  exit 1
else
  puts "PASS: All #{providers.size} providers valid"
end

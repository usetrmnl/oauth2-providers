#!/usr/bin/env ruby
# frozen_string_literal: true

# Validates providers.yml, sorts alphabetically by keyname, and generates JSON
# Run: ruby .github/scripts/validate_providers.rb

require "yaml"
require "json"

PROVIDERS_PATH = File.expand_path("../../providers.yml", __dir__)
JSON_PATH = File.expand_path("../../generated_providers.json", __dir__)

REQUIRED_FIELDS = %w[keyname display_name category authorize_url token_url pkce_enabled].freeze

VALID_CATEGORIES = %w[
  ai analytics communication content crm design dev-tools e-commerce
  education entertainment file-storage finance fitness gaming healthcare
  hr identity logistics marketing other productivity security smart-home
  social support travel
].freeze

# --- Step 1: Validate ---

errors = []

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

keynames = []

providers.each_with_index do |provider, index|
  label = provider["keyname"] || "entry ##{index + 1}"

  REQUIRED_FIELDS.each do |field|
    if provider[field].nil? || provider[field].to_s.strip.empty?
      errors << "#{label}: missing required field '#{field}'"
    end
  end

  keyname = provider["keyname"].to_s
  if keynames.include?(keyname)
    errors << "#{label}: duplicate keyname"
  end
  keynames << keyname

  %w[authorize_url token_url].each do |url_field|
    url = provider[url_field].to_s
    next if url.empty?

    unless url.start_with?("https://") || url.include?("${connectionConfig")
      errors << "#{label}: #{url_field} must start with https:// or contain ${connectionConfig"
    end
  end

  category = provider["category"].to_s
  unless category.empty? || VALID_CATEGORIES.include?(category)
    errors << "#{label}: invalid category '#{category}' (valid: #{VALID_CATEGORIES.join(", ")})"
  end

  pkce = provider["pkce_enabled"].to_s
  unless %w[yes no].include?(pkce)
    errors << "#{label}: pkce_enabled must be 'yes' or 'no', got '#{pkce}'"
  end
end

if errors.any?
  puts "\nFAIL: #{errors.size} validation error(s)\n\n"
  errors.each { |e| puts "  - #{e}" }
  exit 1
end

puts "PASS: All #{providers.size} providers valid"

# --- Step 2: Sort YAML by keyname ---

raw = File.read(PROVIDERS_PATH)
first_entry = raw.index("\n- keyname:")
header = raw[0..first_entry]
body = raw[(first_entry + 1)..]

blocks = body.split(/(?=^- keyname:)/m).reject { |b| b.strip.empty? }
sorted = blocks.sort_by { |b| b[/^- keyname:\s*(.+)/, 1].strip }

output = header + sorted.map(&:strip).join("\n\n") + "\n"
File.write(PROVIDERS_PATH, output)
puts "Sorted #{blocks.size} providers alphabetically by keyname"

# --- Step 3: Generate JSON ---

json = JSON.pretty_generate(YAML.load_file(PROVIDERS_PATH), indent: "  ")
File.write(JSON_PATH, "#{json}\n")
puts "Generated generated_providers.json with #{providers.size} providers"

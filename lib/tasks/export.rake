# frozen_string_literal: true

namespace :export do
  desc 'Prints Member.all in a seeds.rb way.'
  task seeds_format: :environment do
    Member.order(:id).all.each do |member|
      puts "Member.create(#{member.serializable_hash.delete_if do |key, _value|
                              %w[created_at updated_at id].include?(key)
                            end.to_s.gsub(/[{}]/, '')})"
    end
  end
end

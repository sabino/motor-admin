# frozen_string_literal: true

require 'google/cloud/bigquery'
require 'cgi'

module Motor
  module BigQuery
    module_function

    # Parse BigQuery connection URL and return [project_id, dataset, credentials]
    def parse_url(url)
      uri = URI.parse(url)
      params = CGI.parse(uri.query.to_s)

      [uri.host, uri.path.delete_prefix('/'), params['credentials']&.first]
    end

    # Create BigQuery client using URL credentials
    def create_client(url)
      project_id, _dataset, credentials = parse_url(url)
      Google::Cloud::Bigquery.new(project: project_id, credentials: credentials)
    end

    # Verify that provided BigQuery connection URL is accessible
    def verify!(url)
      project_id, dataset, = parse_url(url)
      create_client(url).dataset(dataset) || raise(StandardError, 'Invalid dataset')
    end

    # Fetch tables and columns metadata for given BigQuery URL
    def fetch_metadata(url)
      client = create_client(url)
      _project_id, dataset_name, = parse_url(url)
      dataset = client.dataset(dataset_name)

      dataset.tables.map do |table|
        {
          name: table.table_id,
          columns: table.fields.map { |f| { name: f.name, type: f.type } }
        }
      end
    end
  end
end

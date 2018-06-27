module AcademicBenchmarksApi
  class FacetSerializer

    def self.serialize(data, child_route)
      facet = {}
      facet[:type] = 'facets'
      facet[:id] = data['data']['guid']
      facet[:attributes] = {}
      facet[:attributes][:title] = data['data']['title']
      facet[:attributes][:descr] = data['data']['descr']
      facet[:attributes][:acronym] = data['data']['acronym']
      facet[:attributes][:adopt_year] = data['data']['adopt_year']
      facet[:meta] = {:count => data['count'], :child_route => child_route}

      facet
    end
  end
end
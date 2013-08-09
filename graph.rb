require File.join(File.dirname(__FILE__), 'route.rb')

class Graph < Array
  attr_reader :edges
  
  def initialize(subway)
    @edges = []
    @vertices = []
    @neighbors = {}

    subway.lines.each do |line|
      line.stations.each_with_index do |station, index|
        @vertices << station unless @vertices.include? station
        connect_mutually(station, line.stations[index+1]) unless (index >= line.stations.length-1)
      end
    end

    @distances = {}
    @routes = {}
    @vertices.each do |vertex|
      routes_for(vertex)
    end
  end
  
  def length_between(src, dst)
    @edges.each do |edge|
      return edge.length if edge.src == src and edge.dst == dst
    end
    nil
  end
 
  def route(src, dst)
    @routes[[src, dst]]
  end
  def routes
    @routes.values.reject {|route| route.nil? || route.stations.length <= 1}
  end

  private
  def connect_mutually(src, dst, length = 2.5)
    connect(src, dst, length)
    connect(dst, src, length)
  end
  def connect(src, dst, length)
    @edges.push Edge.new(dst, src, length)
    @neighbors[src] ||= [] 
    @neighbors[src] << dst
  end

  def routes_for(src)
    @vertices.each do |vertex|
      @distances[[src, vertex]] = nil # Infinity
      @routes[[src, vertex]] = Route.new [src]
    end
    @distances[[src, src]] = 0
    vertices = @vertices.clone

    until vertices.empty?
      nearest_vertex = vertices.inject do |a, b|
        next b unless @distances[[src, a]] 
        next a unless @distances[[src, b]]
        next a if @distances[[src, a]] < @distances[[src, b]]
        b
      end
      # p "--------nearest_vertex: #{src}, #{nearest_vertex}"
      break unless @distances[[src, nearest_vertex]] # Infinity
      neighbors = @neighbors[nearest_vertex]
      # p "nearest_vertex: #{nearest_vertex}, distances[#{src}][#{nearest_vertex}]: #{@distances[src][nearest_vertex]},neighbors: #{neighbors}"
      neighbors.each do |vertex|
        # alt = @distances[[src, nearest_vertex]] + self.length_between(nearest_vertex, vertex)
        newRoute =Route.new(@routes[[src, nearest_vertex]].stations + [vertex])
        # p "vertex: #{vertex}, vertices.length_between(#{nearest_vertex}, #{vertex}): #{vertices.length_between(nearest_vertex, vertex)}, alt: #{alt}"
        if @distances[[src, vertex]].nil? || newRoute.total_time < @distances[[src, vertex]]
          @distances[[src, vertex]] = newRoute.total_time 
          @routes[[src, vertex]] = newRoute
        end
      end
      vertices.delete nearest_vertex
    end
  end
end

class Edge
  attr_accessor :src, :dst, :length
  
  def initialize(src, dst, length=2.5)
    @src = src
    @dst = dst
    @length = length
  end
end
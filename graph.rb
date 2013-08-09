class Graph < Array
  attr_reader :edges
  
  def initialize
    @edges = []
    @vertices = []
    @neighbors = []
  end
  
  def connect_mutually(src, dst, length = 2.5)
    connect src, dst, length
    connect dst, src, length
    @vertices << src unless @vertices.include? src
    @vertices << dst unless @vertices.include? dst
  end
  
  def length_between(src, dst)
    @edges.each do |edge|
      return edge.length if edge.src == src and edge.dst == dst
    end
    nil
  end
 
  def route(src, dst)
    init_routes() if @routes.nil?
    @routes[[src, dst]]
  end
  def init_routes
    @distances ||= {}
    @routes ||= {}
    @vertices.each do |vertex|
      routes_for(vertex)
    end
    @routes.values.reject {|route| route.length <= 1}
  end

  private
  def connect(src, dst, length = 2.5)
    @edges.push Edge.new(src, dst, length)
    @neighbors[src] = [] if @neighbors[src].nil?
    @neighbors[src] << dst
  end

  def routes_for(src)
    @vertices.each do |vertex|
      @distances[[src, vertex]] = nil # Infinity
      @routes[[src, vertex]] = [src]
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
        alt = @distances[[src, nearest_vertex]] + self.length_between(nearest_vertex, vertex)
        # p "vertex: #{vertex}, vertices.length_between(#{nearest_vertex}, #{vertex}): #{vertices.length_between(nearest_vertex, vertex)}, alt: #{alt}"
        if @distances[[src, vertex]].nil? || alt < @distances[[src, vertex]]
          @distances[[src, vertex]] = alt 
          @routes[[src, vertex]] = @routes[[src, nearest_vertex]] + [vertex]
          # p "set @distances[#{src}][#{vertex}] to #{@distances[src][vertex]}, routes: #{@routes[src][vertex]}"
          # decrease-key v in Q # ???
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
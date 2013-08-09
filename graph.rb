class Edge
  attr_accessor :src, :dst, :length
  
  def initialize(src, dst, length=2.5)
    @src = src
    @dst = dst
    @length = length
  end
end
 
class Graph < Array
  attr_reader :edges
  
  def initialize
    @edges = []
  end
  
  def connect(src, dst, length = 2.5)
    unless self.include?(src)
      raise "No such vertex: #{src}"
    end
    unless self.include?(dst)
      raise "No such vertex: #{dst}"
    end
    @edges.push Edge.new(src, dst, length)
  end
  
  def connect_mutually(vertex1, vertex2, length = 2.5)
    self.connect vertex1, vertex2, length
    self.connect vertex2, vertex1, length
  end
 
  def neighbors(vertex)
    neighbors = []
    @edges.each do |edge|
      neighbors.push edge.dst if edge.src == vertex
    end
    return neighbors.uniq
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
    self.each do |vertex|
      routes_for(vertex)
    end
    @routes.values.reject {|route| route.length <= 1}
  end

  private
  def routes_for(src)
    self.each do |vertex|
      @distances[[src, vertex]] = nil # Infinity
      @routes[[src, vertex]] = [src]
    end
    @distances[[src, src]] = 0
    vertices = self.clone

    until vertices.empty?
      nearest_vertex = vertices.inject do |a, b|
        next b unless @distances[[src, a]] 
        next a unless @distances[[src, b]]
        next a if @distances[[src, a]] < @distances[[src, b]]
        b
      end
      # p "--------nearest_vertex: #{src}, #{nearest_vertex}"
      break unless @distances[[src, nearest_vertex]] # Infinity
      neighbors = vertices.neighbors(nearest_vertex)
      # p "nearest_vertex: #{nearest_vertex}, distances[#{src}][#{nearest_vertex}]: #{@distances[src][nearest_vertex]},neighbors: #{neighbors}"
      neighbors.each do |vertex|
        alt = @distances[[src, nearest_vertex]] + vertices.length_between(nearest_vertex, vertex)
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
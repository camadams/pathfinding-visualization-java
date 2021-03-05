import java.util.*;

int lenNode;

int numRowNodes;
int numColNodes;

Node[][] nodes;

boolean[][] grid;

Node endNode;

PriorityQueue<Node> pq;

int[] closed;

void setup() {

  frameRate(10);

  size(600, 600);

  lenNode=10;

  numRowNodes = 600/lenNode;
  numColNodes = 600/lenNode;

  nodes = new Node[numRowNodes][numColNodes];

  grid = new boolean[numRowNodes][numColNodes];

  for (int r=0; r<numRowNodes; r++) {    
    for (int c=0; c<numRowNodes; c++) {
      grid[r][c] = random(100) < 0 ? true : false;
    }
  }


  for (int r=0; r<numRowNodes; r++) {    
    for (int c=0; c<numRowNodes; c++) {
      boolean wall = grid[r][c];
      nodes[r][c] = new Node(r, c, lenNode, wall);
    }
  }

  int[][] DIRECTIONS = new int[][]{{0, -1}, {1, -1}, {1, 0}, {1, 1}, {0, 1}, {-1, 1}, {-1, 0}, {-1, -1}};

  for (int r=0; r<numRowNodes; r++) {
    for (int c=0; c<numRowNodes; c++) {
      for (int[] dir : DIRECTIONS) {
        int nR = r+dir[0];
        int nC = r+dir[1];
        if (nR < 0 || nR >= numRowNodes || nC < 0 || nC >= numColNodes || nodes[nR][nC].wall) continue;
        //println("hello");
        nodes[r][c].neighbours.add( nodes[nR][nC] );
      }
    }
  }

  //int m = grid.length, n = grid[0].length;
  //int endX = m - 1, endY = n - 1;
  Node startNode = nodes[5][5];
  endNode = nodes[20][20];

  // Initialize the open list -> which node we expand next?
  pq = new PriorityQueue<Node>();

  // Initialize the closed list -> which nodes we've already visited? What is the minimum g from start node to this?
  closed = new int[numRowNodes * numColNodes];
  Arrays.fill(closed, Integer.MAX_VALUE);

  // put the starting node on the open list
  startNode.g=0;
  startNode.f= Math.max(numRowNodes, numColNodes);
  startNode.prev=null;
  startNode.visited=true;
  pq.add(startNode);
  //  pq.add(new Node(0, 0, 1, Math.max(m, n)));

}


void draw() {
  //for (int r=0; r<numRowNodes; r++) {    
  //  for (int c=0; c<numRowNodes; c++) {
  //    nodes[r][c].show();
  //  }
  //}
  //println(pq);
  //retrive the node with the least f on the open list, call it "node"
  println(pq.size());
  Node node = pq.remove();

  int r = node.r;
  int c = node.c;
  
  ellipse(c*lenNode,r*lenNode,10,10);

  // skip disallowed area
  //if (x < 0 || x >= m || y < 0 || y >= n || grid[x][y] == 1) continue;

  // if node is the goal, stop search
  if (node==endNode) noLoop();

  // if a node with the same position is in the closed list
  // which has a lower or equals g than this, skip this expansion
  println(closed[r * numRowNodes + c]);
  println(node.g);
  if (closed[r * numRowNodes + c] > node.g) {
    println("hi");
    // push node on the closed list
    closed[r * numRowNodes + c] = node.g;
    // generate 8 successors to node
    for (Node neighbour : node.neighbours) {
      if (neighbour.visited) continue;
      // for each successor
      // successor.g = node.g + distance between successor and node (equals to 1)
      // successor.h = estimate distance from successor to goal
      int g = node.g + 1;

      // h(node) is a heuristic function that 
      // estimates the cost of the cheapest path from node to the goal

      // Here we use **Diagonal Distance** as heuristic function, 
      // because we can and only can move in eight directions
      int h = Math.max(Math.abs(endNode.r - neighbour.r), Math.abs(endNode.c - neighbour.c));

      // push the successor on the open list
      neighbour.g = g;
      neighbour.f = g+h;
      neighbour.prev = node;
      pq.add(neighbour);
    }
  }
  //Node temp = node;
  //while (node.prev!=null) {
  //  println(node.r);
  //  println(node.c);
  //  //println(temp.prev);
  //  println();
  //  ellipse(random(100),random(100),random(100),random(100));
  //  ellipse(node.c*lenNode, node.r*lenNode, 10, 10);
  //  node=node.prev;
  //}
  //node=temp;
}

class Node implements Comparable<Node> {
  int r;
  int c;
  int g; // g(node) is the cost of the path from the start node to node
  int f; // f(node) = g(node) + h(node)
  ArrayList<Node> neighbours;
  boolean wall;
  boolean visited;
  int lenNode;
  Node prev;

  private Node(int r, int c,  int lenNode, boolean wall) {
    this.r = r;
    this.c = c;
    this.neighbours = new ArrayList();
    this.wall = wall;
    this.lenNode = lenNode;
  }

  @Override
    public int compareTo(Node node) {
    return this.f - node.f;
  }

  void show() {
    if (wall) fill(40);
    else fill(200);
    rect(c*lenNode, r*lenNode, lenNode, lenNode);
  }
}



//Node shortestPathBinaryMatrix(Node startNode, Node endNode) {
//  int m = grid.length, n = grid[0].length;
//  int endX = m - 1, endY = n - 1;

//  // Initialize the open list -> which node we expand next?
//  PriorityQueue<Node> pq = new PriorityQueue<Node>();

//  // Initialize the closed list -> which nodes we've already visited? What is the minimum g from start node to this?
//  int[] closed = new int[m * n];
//  Arrays.fill(closed, Integer.MAX_VALUE);

//  // put the starting node on the open list
//  pq.add(new Node(0, 0, 1, Math.max(m, n)));

//  // while the open list is not empty
//  while (!pq.isEmpty()) {

//    // retrive the node with the least f on the open list, call it "node"
//    Node node = pq.remove();

//    int x = node.x;
//    int y = node.y;

//    // skip disallowed area
//    if (x < 0 || x >= m || y < 0 || y >= n || grid[x][y] == 1) continue;

//    // if node is the goal, stop search
//    if (x == endX && y == endY) return node;

//    // if a node with the same position is in the closed list
//    // which has a lower or equals g than this, skip this expansion
//    if (closed[x * m + y] <= node.g) continue;

//    // push node on the closed list
//    closed[x * m + y] = node.g;

//    // generate 8 successors to node
//    for (int[] dir : DIRECTIONS) {
//      // for each successor
//      // successor.g = node.g + distance between successor and node (equals to 1)
//      // successor.h = estimate distance from successor to goal
//      int g = node.g + 1;

//      // h(node) is a heuristic function that 
//      // estimates the cost of the cheapest path from node to the goal

//      // Here we use **Diagonal Distance** as heuristic function, 
//      // because we can and only can move in eight directions
//      int h = Math.max(Math.abs(endX - x), Math.abs(endY - y));

//      // push the successor on the open list
//      Node succ=new Node(x + dir[0], y + dir[1], g, h);
//      succ.prev=node;
//      pq.add(succ);
//    }
//  }

//  return null;
//}
